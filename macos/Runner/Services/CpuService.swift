import Foundation
import MachO

public class CpuService {
    public static let shared = CpuService()
    
    public let cpuName: String
    
    private init() {
        var size = 0
        sysctlbyname("machdep.cpu.brand_string", nil, &size, nil, 0)
        var brand = [CChar](repeating: 0, count: size)
        sysctlbyname("machdep.cpu.brand_string", &brand, &size, nil, 0)
        self.cpuName = String(cString: brand).trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var previousCpuInfo: processor_info_array_t?
    private var previousCpuInfoCount: mach_msg_type_number_t = 0
    private let lock = NSLock()

    public func getCpuUsage() -> [String: Any]? {
        lock.lock()
        defer { lock.unlock() }

        var processorInfo: processor_info_array_t?
        var processorMsgCount: mach_msg_type_number_t = 0
        var processorCount: natural_t = 0
        
        let result = host_processor_info(
            mach_host_self(),
            PROCESSOR_CPU_LOAD_INFO,
            &processorCount,
            &processorInfo,
            &processorMsgCount
        )
        
        guard result == KERN_SUCCESS, let currentInfo = processorInfo else {
            return nil
        }
        
        var totalUserDelta: Int32 = 0
        var totalSystemDelta: Int32 = 0
        var totalIdleDelta: Int32 = 0

        if let prevInfo = previousCpuInfo {
            for i in 0..<Int(processorCount) {
                let baseOffset = i * Int(CPU_STATE_MAX)
                
                let currentUser = currentInfo[baseOffset + Int(CPU_STATE_USER)]
                let currentNice = currentInfo[baseOffset + Int(CPU_STATE_NICE)]
                let currentSystem = currentInfo[baseOffset + Int(CPU_STATE_SYSTEM)]
                let currentIdle = currentInfo[baseOffset + Int(CPU_STATE_IDLE)]
                
                let prevUser = prevInfo[baseOffset + Int(CPU_STATE_USER)]
                let prevNice = prevInfo[baseOffset + Int(CPU_STATE_NICE)]
                let prevSystem = prevInfo[baseOffset + Int(CPU_STATE_SYSTEM)]
                let prevIdle = prevInfo[baseOffset + Int(CPU_STATE_IDLE)]
                
                totalUserDelta += (currentUser - prevUser) + (currentNice - prevNice)
                totalSystemDelta += (currentSystem - prevSystem)
                totalIdleDelta += (currentIdle - prevIdle)
            }
            
            vm_deallocate(mach_task_self_, vm_address_t(bitPattern: prevInfo), vm_size_t(previousCpuInfoCount * UInt32(MemoryLayout<integer_t>.size)))
        }
        
        previousCpuInfo = currentInfo
        previousCpuInfoCount = processorMsgCount
        
        let totalDelta = totalUserDelta + totalSystemDelta + totalIdleDelta
        
        guard totalDelta > 0 else {
            return [
                "name": cpuName,
                "totalLoad": 0.0,
                "user": 0.0,
                "system": 0.0,
                "idle": 100.0
            ]
        }
        
        let userPercent = (Double(totalUserDelta) / Double(totalDelta)) * 100.0
        let systemPercent = (Double(totalSystemDelta) / Double(totalDelta)) * 100.0
        let idlePercent = (Double(totalIdleDelta) / Double(totalDelta)) * 100.0
        let totalLoad = userPercent + systemPercent

        return [
            "name": cpuName,
            "totalLoad": totalLoad,
            "user": userPercent,
            "system": systemPercent,
            "idle": idlePercent
        ]
    }
}
