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
}
