import Foundation

public typealias RefreshTokenHandlerWithParam = ((_ closure: (@escaping (_ token: String?) -> Void), _ isExpired: Bool) -> Void)

@objcMembers public class VoxeetSDK: NSObject {
    
    public static var shared: VoxeetSDK = VoxeetSDK()
    
    public let session = SessionService()
    public let conference = ConferenceService()
    public let recording = RecordingService()
    public let command = CommandService()
    public let mediaDevice = MediaDeviceService()
    public let videoPresentation = VideoPresentationService()
    public let notification = NotificationService()
    public let filePresentation = FilePresentationService()
    
    public var initializeArgs: (consumerKey: String, consumerSecret: String)?
    public func initialize(consumerKey: String, consumerSecret: String) {
        initializeArgs = (consumerKey, consumerSecret)
    }

    public var initializeWithTokenArgs: (accessToken: String, refreshToken: RefreshTokenHandlerWithParam)?
    public func initialize(accessToken: String, refreshTokenClosureWithParam: @escaping RefreshTokenHandlerWithParam){
        initializeWithTokenArgs = (accessToken, refreshTokenClosureWithParam)

    }
}
