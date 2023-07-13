import Foundation

@objcMembers public class SessionService: NSObject {
    
    public var isOpen: Bool = false
    
    public internal(set) var participant: VTParticipant?
    
    public func open(info: VTParticipantInfo? = nil, completion: ((_ error: NSError?) -> Void)? = nil) {
        fatalError("Mock method not implemented")
    }
    
    var closeHasRun: Bool = false
    var closeReturn: NSError?
    public func close(completion: ((_ error: NSError?) -> Void)? = nil) {
        closeHasRun = true
        completion?(closeReturn)
    }

    var updateParticipantInfoHasRun: Bool = false
    var updateParticipantInfoArgs: (name: String, avatarUrl: String)?
    var updateParticipantInfoReturn: NSError?
    public func updateParticipantInfo(name: String, avatarUrl: String, completion: ((_ error: NSError?) -> Void)? = nil) {
        updateParticipantInfoHasRun = true
        updateParticipantInfoArgs = (name: name, avatarUrl: avatarUrl)
        completion?(updateParticipantInfoReturn)
    }
}
