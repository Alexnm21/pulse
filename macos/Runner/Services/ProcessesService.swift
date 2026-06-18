import Foundation

public class ProcessesService {
    public static let shared = ProcessesService()

    private var previousCpuTicks: [pid_t: UInt64] = [:]
    private var previousTimestamp: UInt64 = 0
    private let lock = NSLock()

    private init() {}

    public func getProcesses() -> [[String: Any]] {
        lock.lock()
        defer { lock.unlock() }

        let physicalMemory = ProcessInfo.processInfo.physicalMemory
        let currentTimestamp = clock_gettime_nsec_np(CLOCK_UPTIME_RAW)
        let elapsedSec = previousTimestamp > 0
            ? Double(currentTimestamp - previousTimestamp) / 1_000_000_000.0
            : 1.0

        var pidBuffer = [pid_t](repeating: 0, count: 4096)
        let pidCount = proc_listallpids(&pidBuffer, Int32(MemoryLayout<pid_t>.stride * pidBuffer.count))
        guard pidCount > 0 else { return [] }

        var processes: [[String: Any]] = []
        var newCpuTicks: [pid_t: UInt64] = [:]

        for i in 0..<Int(pidCount) {
            let pid = pidBuffer[i]
            guard pid > 0 else { continue }

            var taskInfo = proc_taskinfo()
            let taskSize = MemoryLayout<proc_taskinfo>.stride
            let taskResult = proc_pidinfo(pid, PROC_PIDTASKINFO, 0, &taskInfo, Int32(taskSize))

            guard taskResult >= taskSize else { continue }

            let totalTicks = taskInfo.pti_total_user + taskInfo.pti_total_system
            newCpuTicks[pid] = totalTicks

            let prevTicks = previousCpuTicks[pid] ?? totalTicks
            let deltaTicks = totalTicks > prevTicks ? totalTicks - prevTicks : 0

            let cpuUsage = elapsedSec > 0
                ? min((Double(deltaTicks) / elapsedSec) / 100.0, 100.0)
                : 0.0

            let memoryBytes = taskInfo.pti_resident_size
            let memoryUsage = physicalMemory > 0
                ? (Double(memoryBytes) / Double(physicalMemory)) * 100.0
                : 0.0

            var procInfo = proc_bsdinfo()
            let procSize = MemoryLayout<proc_bsdinfo>.stride
            let procResult = proc_pidinfo(pid, PROC_PIDTBSDINFO, 0, &procInfo, Int32(procSize))
            guard procResult >= procSize else { continue }

            let processName = withUnsafePointer(to: procInfo.pbi_name) {
                $0.withMemoryRebound(to: UInt8.self, capacity: Int(MAXCOMLEN)) { ptr in
                    String(cString: ptr)
                }
            }

            let username = usernameForUID(procInfo.pbi_uid)

            processes.append([
                "name": processName.isEmpty ? "?" : processName,
                "cpuUsage": cpuUsage,
                "memoryUsage": memoryUsage,
                "user": username,
            ])
        }

        previousCpuTicks = newCpuTicks
        previousTimestamp = currentTimestamp

        return processes
    }

    private func usernameForUID(_ uid: UInt32) -> String {
        guard let pw = getpwuid(uid) else { return "?" }
        return String(cString: pw.pointee.pw_name)
    }
}
