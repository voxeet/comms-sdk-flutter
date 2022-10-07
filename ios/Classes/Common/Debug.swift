import Foundation

protocol Debug {
    var debugDescription: String { get }
}

extension Debug {
    var debugDescription: String {
        return String(reflecting: self)
    }
}
