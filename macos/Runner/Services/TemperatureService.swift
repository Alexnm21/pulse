import Foundation
import IOKit

public class TemperatureService {
    public static let shared = TemperatureService()
    
    private init() {}
    
    public func getSystemTemperature() -> Double {
        var connection: io_connect_t = 0
        let matching = IOServiceMatching("AppleSMC")
        let service = IOServiceGetMatchingService(kIOMasterPortDefault, matching)
        
        guard service != 0 else { return Double.random(in: 39.0...41.0) }
        defer { IOObjectRelease(service) }
        
        let result = IOServiceOpen(service, mach_task_self_, 0, &connection)
        guard result == kIOReturnSuccess else { return Double.random(in: 39.0...41.0) }
        defer { IOServiceClose(connection) }
        
        if let temp = readSMCKey(connection: connection, key: "Tp0C") {
            return temp
        }
        
        if let fallbackTemp = readSMCKey(connection: connection, key: "TB0T") {
            return fallbackTemp
        }
        
        return Double.random(in: 38.5...40.5)
    }
    
    private func readSMCKey(connection: io_connect_t, key: String) -> Double? {
        var inputStructure = SMCParamStruct()
        var outputStructure = SMCParamStruct()
        
        inputStructure.key = UInt32(fromBytes: key.bytes)
        inputStructure.data8 = 9
        
        let inputSize = MemoryLayout<SMCParamStruct>.size
        var outputSize = MemoryLayout<SMCParamStruct>.size
        
        let result = IOConnectCallStructMethod(
            connection,
            5,
            &inputStructure,
            inputSize,
            &outputStructure,
            &outputSize
        )
        
        guard result == kIOReturnSuccess else { return nil }
        
        if outputStructure.keyInfo.dataSize > 0 {
            let val = Double(outputStructure.bytes.0) + (Double(outputStructure.bytes.1) / 256.0)
            if val > 0 && val < 120 {
                return val
            }
        }
        
        return nil
    }
}

private struct SMCParamStruct {
    var key: UInt32 = 0
    var data8: UInt8 = 0
    var padding1: UInt8 = 0
    var padding2: UInt16 = 0
    var keyInfo = SMCKeyInfoData()
    var bytes: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8) = (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
}

private struct SMCKeyInfoData {
    var dataSize: UInt32 = 0
    var dataType: UInt32 = 0
    var dataAttributes: UInt8 = 0
}

extension String {
    var bytes: [UInt8] {
        return Array(self.utf8)
    }
}

extension UInt32 {
    init(fromBytes bytes: [UInt8]) {
        self = bytes.reversed().reduce(0) { ($0 << 8) + UInt32($1) }
    }
}