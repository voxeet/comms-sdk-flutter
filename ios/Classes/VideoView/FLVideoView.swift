import Flutter
import UIKit
import VoxeetSDK

class FLVideoView: NSObject, FlutterPlatformView {
    
    private let _view: VTVideoView
    private let methodChannel: FlutterMethodChannel
    
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        guard let messenger = messenger else {
            fatalError("FLVideoView: Did not receive a binnary messenger.")
        }
        methodChannel = FlutterMethodChannel(name: "video_view_\(viewId)_method_channel", binaryMessenger: messenger)
        _view = VTVideoView()
        super.init()

        methodChannel.setMethodCallHandler { [weak self] (call, result) in
            self?.handle(
                methodName: call.method,
                flutterArguments: FlutterMethodCallArguments(methodCallArguments: call.arguments),
                completionHandler: FlutterMethodCallCompletionHandler(flutterResult: result)
            )
        }
    }
    
    func view() -> UIView {
        return _view
    }

    func attach(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            let participantId: String? = try flutterArguments.asDictionary(argKey: "participant_id").decode()
            let mediaStreamId: String? = try flutterArguments.asDictionary(argKey: "media_stream_id").decode()
            try attach(participantId: participantId, mediaStreamId: mediaStreamId)
        } catch {
            completionHandler.failure(error)
        }
    }

    func detach(
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        _view.unattach()
        completionHandler.success(flutterConvertible: true)
    }

    func isAttached(
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        completionHandler.success(flutterConvertible: _view.mediaStream != nil)
    }

    func isScreenShare(
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        completionHandler.success(flutterConvertible: false) // TODO: Implement this properly
    }
    
    private func attach(participantId: String?, mediaStreamId: String?) throws {
        guard
            let participantId = participantId, participantId != "",
            let mediaStreamId = mediaStreamId, mediaStreamId != "",
            let currentConference = VoxeetSDK.shared.conference.current,
            let participantObject = currentConference.findParticipant(with: participantId),
            let mediaStreamObject
                    = participantObject.streams.first(where: { $0.streamId == mediaStreamId }),
            mediaStreamObject.videoTracks.count > 0
        else {
            _view.unattach()
            return
        }
        _view.attach(participant: participantObject, stream: mediaStreamObject)
    }
}

extension FLVideoView: FlutterBinding {
    func handle(
        methodName: String,
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        switch methodName {
        case "attach":
            attach(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "detach":
            detach(completionHandler: completionHandler)
        case "isAttached":
            isAttached(completionHandler: completionHandler)
        case "isScreenShare":
            isScreenShare(completionHandler: completionHandler)
        default:
            completionHandler.methodNotImplemented()
        }
    }
}
