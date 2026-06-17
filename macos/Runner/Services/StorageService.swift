import Foundation

public class StorageService {
    public static let shared = StorageService()
    
    private init() {}
    
    public func getStorageUsage() -> [String: Any]? {
        let fileURL = URL(fileURLWithPath: "/")
        
        do {
            let values = try fileURL.resourceValues(forKeys: [.volumeTotalCapacityKey, .volumeAvailableCapacityKey])
            
            let totalSpace = Double(values.volumeTotalCapacity ?? 0) / (1024.0 * 1024.0 * 1024.0)
            let freeSpace = Double(values.volumeAvailableCapacity ?? 0) / (1024.0 * 1024.0 * 1024.0)
            let usedSpace = totalSpace - freeSpace
            
            return [
                "totalStorage": totalSpace,
                "freeStorage": freeSpace,
                "usedStorage": usedSpace
            ]
        } catch {
            return nil
        }
    }
}
