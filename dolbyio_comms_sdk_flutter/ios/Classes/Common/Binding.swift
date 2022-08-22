import Foundation

class Binding {
    
	let channel: FlutterMethodChannel
    let nativeEventEmitter: NativeEventEmitter

    init(name: String, registrar: FlutterPluginRegistrar) {
        self.channel = FlutterMethodChannel(name: "dolbyio_\(name)_channel", binaryMessenger: registrar.messenger())
        self.nativeEventEmitter = NativeEventEmitter(
            name: "dolbyio_\(name)_event_channel",
            registrar: registrar
        )
		channel.setMethodCallHandler { [weak self] call, result in
			guard let self = self as? FlutterBinding else { return }
			self.handle(
				methodName: call.method,
				flutterArguments: FlutterMethodCallArguments(methodCallArguments: call.arguments),
				completionHandler: FlutterMethodCallCompletionHandler(flutterResult: result)
			)
		}
        onInit()
	}
	
    func onInit() { }
}
