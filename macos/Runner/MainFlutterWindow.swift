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


  }
}