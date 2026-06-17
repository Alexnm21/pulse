import Foundation

public class MemoryService {
    public static let shared = MemoryService()
    
    private init() {}
    
    public func getMemoryUsage() -> [String: Any]? {
        let physicalMemory = ProcessInfo.processInfo.physicalMemory
        let totalSystemMemoryGB = Double(physicalMemory) / (1024.0 * 1024.0 * 1024.0)
        
        var taskInfo = mach_task_basic_info()
        var taskCount = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4
        
        let taskResult = withUnsafeMutablePointer(to: &taskInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) { ptr in
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), ptr, &taskCount)
            }
        }
        
        let appUsedGB = taskResult == KERN_SUCCESS ? Double(taskInfo.resident_size) / (1024.0 * 1024.0 * 1024.0) : 0.0
        
        var vmStats = vm_statistics64()
        var vmCount = mach_msg_type_number_t(MemoryLayout<vm_statistics64_data_t>.size / MemoryLayout<integer_t>.size)
        let hostPort = mach_host_self()
        
        let vmResult = withUnsafeMutablePointer(to: &vmStats) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(vmCount)) { ptr in
                host_statistics64(hostPort, HOST_VM_INFO64, ptr, &vmCount)
            }
        }
        
        var pageSize: vm_size_t = 0
        host_page_size(hostPort, &pageSize)
        
        var wiredMemoryGB = 0.0
        var compressedMemoryGB = 0.0
        var usedMemoryGB = 0.0
        
        if vmResult == KERN_SUCCESS {
            let multiplier = Double(pageSize) / (1024.0 * 1024.0 * 1024.0)
            wiredMemoryGB = Double(vmStats.wire_count) * multiplier
            compressedMemoryGB = Double(vmStats.compressor_page_count) * multiplier
            
            let freeMemoryGB = Double(vmStats.free_count) * multiplier
            usedMemoryGB = totalSystemMemoryGB - freeMemoryGB
        }
        
        return [
            "totalMemory": totalSystemMemoryGB,
            "usedMemory": usedMemoryGB,
            "appMemory": appUsedGB,
            "wiredMemory": wiredMemoryGB,
            "compressedMemory": compressedMemoryGB
        ]
    }
}