import Foundation

public class ProcessesService {
    public static let shared = ProcessesService()

    private var previousCpuTicks: [pid_t: UInt64] = [:]
    private var previousTimestamp: UInt64 = 0
    private let lock = NSLock()
    private let timebaseNumer: UInt32
    private let timebaseDenom: UInt32

    private init() {
        var info = mach_timebase_info()
        mach_timebase_info(&info)
        timebaseNumer = info.numer
        timebaseDenom = info.denom
    }

    public func getProcesses() -> [[String: Any]] {
        lock.lock()
        defer { lock.unlock() }

        let currentTimestamp = clock_gettime_nsec_np(CLOCK_UPTIME_RAW)
        let elapsedSec = previousTimestamp > 0
            ? Double(currentTimestamp - previousTimestamp) / 1_000_000_000.0
            : 1.0

        var mib = [CTL_KERN, KERN_PROC, KERN_PROC_ALL]
        var bufferSize = 0
        sysctl(&mib, UInt32(mib.count), nil, &bufferSize, nil, 0)
        guard bufferSize > 0 else { return [] }

        var procEntries = [kinfo_proc](repeating: kinfo_proc(), count: bufferSize / MemoryLayout<kinfo_proc>.size)
        sysctl(&mib, UInt32(mib.count), &procEntries, &bufferSize, nil, 0)

        let actualCount = bufferSize / MemoryLayout<kinfo_proc>.size

        var processes: [[String: Any]] = []
        var newCpuTicks: [pid_t: UInt64] = [:]

        for i in 0..<actualCount {
            let kp = procEntries[i]
            let pid = kp.kp_proc.p_pid
            guard pid > 0 else { continue }

            let processName = withUnsafePointer(to: kp.kp_proc.p_comm) { ptr in
                ptr.withMemoryRebound(to: UInt8.self, capacity: Int(MAXCOMLEN)) { p in
                    String(cString: p)
                }
            }

            let username = usernameForUID(kp.kp_eproc.e_ucred.cr_uid)

            var cpuUsage = 0.0
            var memoryUsage = 0.0

            var taskInfo = proc_taskinfo()
            let taskResult = proc_pidinfo(
                pid, PROC_PIDTASKINFO, 0,
                &taskInfo, Int32(MemoryLayout<proc_taskinfo>.size)
            )

            if taskResult >= MemoryLayout<proc_taskinfo>.size {
                let totalTicks = taskInfo.pti_total_user + taskInfo.pti_total_system
                newCpuTicks[pid] = totalTicks

                let prevTicks = previousCpuTicks[pid] ?? totalTicks
                let deltaTicks = totalTicks > prevTicks ? totalTicks - prevTicks : 0

                let deltaNS = Double(deltaTicks) * Double(timebaseNumer) / Double(timebaseDenom)
                cpuUsage = elapsedSec > 0
                    ? min((deltaNS / 1_000_000_000.0 / elapsedSec) * 100.0, 100.0)
                    : 0.0

                memoryUsage = Double(taskInfo.pti_resident_size) / 1024.0 / 1024.0
            }

            processes.append([
                "pid": pid,
                "name": processName.isEmpty ? "?" : processName,
                "cpuUsage": cpuUsage,
                "memoryUsageMB": memoryUsage,
                "user": username,
            ])
        }

        previousCpuTicks = newCpuTicks
        previousTimestamp = currentTimestamp

        return processes
    }

    public func killProcess(pid: Int32) -> [String: Any] {
        // Step 1: get the bundle identifier from System Events
        let getBundleIdScript = """
        tell application "System Events"
            set bundleID to bundle identifier of first process whose unix id is \(pid)
            return bundleID
        end tell
        """

        var error: NSDictionary?
        let getIdAppleScript = NSAppleScript(source: getBundleIdScript)
        let idResult = getIdAppleScript?.executeAndReturnError(&error)

        if let errorDict = error {
            let msg = errorDict[NSAppleScript.errorMessage] as? String ?? "Unknown error"
            return ["success": false, "message": msg]
        }

        guard let bundleID = idResult?.stringValue, !bundleID.isEmpty else {
            return ["success": false, "message": "Process not found in System Events"]
        }

        // Step 2: send quit directly by bundle identifier
        let quitScript = """
        tell application id "\(bundleID)"
            quit
        end tell
        """

        let quitAppleScript = NSAppleScript(source: quitScript)
        quitAppleScript?.executeAndReturnError(&error)

        if let errorDict = error {
            let msg = errorDict[NSAppleScript.errorMessage] as? String ?? "Unknown error"
            return ["success": false, "message": msg]
        }

        return ["success": true, "message": "Process terminated"]
    }

    private func usernameForUID(_ uid: UInt32) -> String {
        guard let pw = getpwuid(uid) else { return "?" }
        return String(cString: pw.pointee.pw_name)
    }
}
