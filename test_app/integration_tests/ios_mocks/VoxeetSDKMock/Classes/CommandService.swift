import Foundation

@objcMembers public class CommandService: NSObject {
    
    public weak var delegate: VTCommandDelegate?
    
    var sendArgs: String?
    var sendReturn: NSError?
    public func send(message: String, completion: ((_ error: NSError?) -> Void)? = nil) {
        sendArgs = message
        completion?(sendReturn)
    }
}

@objc public protocol VTCommandDelegate {
    @objc func received(participant: VTParticipant, message: String)
}
