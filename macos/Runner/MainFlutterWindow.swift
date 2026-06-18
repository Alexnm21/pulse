import Cocoa
import FlutterMacOS

public class MainFlutterWindow: NSWindow {
  
  override public func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)
    RegisterMethodChannels(controller: flutterViewController)

    super.awakeFromNib()
  }

  private func RegisterMethodChannels(controller: FlutterViewController) {
    let binaryMessenger = controller.engine.binaryMessenger
    
    // * CPU Channel
    let cpuChannel = FlutterMethodChannel(name: "com.pulse.app/cpu", binaryMessenger: binaryMessenger)
    cpuChannel.setMethodCallHandler { (call, result) in
        if call.method == "getCpuUsage" {
            if let data = CpuService.shared.getCpuUsage() { result(data) } 
            else { result(FlutterError(code: "ERR", message: "CPU falló", details: nil)) }
        }
    }

    // * Memory Channel
    let memoryChannel = FlutterMethodChannel(name: "com.pulse.app/memory", binaryMessenger: binaryMessenger)
    memoryChannel.setMethodCallHandler { (call, result) in
        if call.method == "getMemoryUsage" {
            if let data = MemoryService.shared.getMemoryUsage() { result(data) } 
            else { result(FlutterError(code: "ERR", message: "Memory falló", details: nil)) }
        }
    }

    let temperatureChannel = FlutterMethodChannel(name: "com.pulse.app/temperature", binaryMessenger: binaryMessenger)
    temperatureChannel.setMethodCallHandler { (call, result) in
        if call.method == "getTemperature" {
            let temp = TemperatureService.shared.getSystemTemperature()
            result(temp)
        }
    }

    let storageChannel = FlutterMethodChannel(name: "com.pulse.app/storage", binaryMessenger: binaryMessenger)
    storageChannel.setMethodCallHandler { (call, result) in
        if call.method == "getStorageUsage" {
        if let data = StorageService.shared.getStorageUsage() {
            result(data)
        } else {
            result(FlutterError(code: "ERR", message: "Storage falló", details: nil))
        }
    }
}

    // * Processes Channel
    let processesChannel = FlutterMethodChannel(name: "com.pulse.app/processes", binaryMessenger: binaryMessenger)
    processesChannel.setMethodCallHandler { (call, result) in
        if call.method == "getProcesses" {
            result(ProcessesService.shared.getProcesses())
        }
    }
  }
}