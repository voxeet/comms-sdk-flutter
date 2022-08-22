import Foundation
import Flutter

class NativeEventEmitter: NSObject {
    
    let eventChannel: FlutterEventChannel
    
    var eventSink: FlutterEventSink?
    
    init(name: String, registrar: FlutterPluginRegistrar) {
        eventChannel = FlutterEventChannel(
            name: name,
            binaryMessenger: registrar.messenger()
        )
        super.init()
        eventChannel.setStreamHandler(self)
    }
    
    func sendEvent<E: RawRepresentable, B: Encodable>(event: E, body: B) throws where E.RawValue == String {
        guard let eventSink = eventSink else {
            return
        }
        eventSink([
            "key": event.rawValue.toFlutterValue(),
            "body": try FlutterValueEncoder().encode(e: body)
        ])
    }
    
    func sendEvent<E: RawRepresentable, B: FlutterConvertible>(
        event: E, body: B
    ) throws where E.RawValue == String {
        guard let eventSink = eventSink else {
            return
        }
        eventSink([
            "key": event.rawValue.toFlutterValue(),
            "body": body.toFlutterValue()
        ])
    }    
}

extension NativeEventEmitter: FlutterStreamHandler {
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        print("Setting event sink")
        eventSink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
}
