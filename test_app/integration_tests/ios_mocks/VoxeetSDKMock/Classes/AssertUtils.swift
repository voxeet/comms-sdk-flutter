import Foundation

public enum SDKAssertError: Error {
    case failure(
        actualValue: String, expectedValue: String,
        msg: String?,
        fileName: String, functionName: String, lineNumber: Int
    )
    case failureWithoutValue(msg: String?, fileName: String, functionName: String, lineNumber: Int)
    case unknownAssert
    
    static func toResult(error: Error) -> SDKAssertResult {
        guard let error = error as? SDKAssertError else {
            return .failure(.unknownAssert)
        }
        return .failure(error)
    }
}

public typealias SDKAssertResult = Result<Void, SDKAssertError>

public protocol AssertsMethodChannelDelegate: AnyObject {
    func runAssert(_ assert: String, args: [String: Any], result: (SDKAssertResult) -> Void)
}

public protocol AssertsMethodChannel {
    var delegate: AssertsMethodChannelDelegate? { get set }
}

public protocol AssertsMethodChannelFactory {
    func createAssertMethodChannel(delegate: AssertsMethodChannelDelegate, channelName: String) -> AssertsMethodChannel
}

protocol SDKAsserts: AssertsMethodChannelDelegate {
    var methodChannel: AssertsMethodChannel? { set get }
}

extension AssertsMethodChannelFactory {
    func createAssertMethodChannel(forSdkAsserts sdkAssert: SDKAsserts, channelName: String) {
        sdkAssert.methodChannel = createAssertMethodChannel(delegate: sdkAssert, channelName: channelName)
    }
}

public var assertsMethodChannelFactory: AssertsMethodChannelFactory! = nil

func nativeAssertEquals<T: Equatable>(
    _ value: T, _ expectedValue: T,
    msg: String? = nil,
    fileName: String = #file, functionName: String = #function, lineNumber: Int = #line
) throws {
    if value != expectedValue {
        throw SDKAssertError.failure(
            actualValue: "\(value)", expectedValue: "\(expectedValue)",
            msg: msg,
            fileName: fileName, functionName: functionName, lineNumber: lineNumber
        )
    }
}

func nativeFail(
    msg: String? = nil,
    fileName: String = #file, functionName: String = #function, lineNumber: Int = #line
) throws {
    throw SDKAssertError.failureWithoutValue(
        msg: msg,
        fileName: fileName, functionName: functionName, lineNumber: lineNumber
    )
}

func ifKeyExists<T>(
    arg: [String: Any], key: String,
    fileName: String = #file, functionName: String = #function, lineNumber: Int = #line,
    closure: (T) throws -> Void
) throws {
    if let value = arg[key] {
        guard let returnValue = value as? T else {
            throw SDKAssertError.failureWithoutValue(
                msg: "nativeCast: Cast failed",
                fileName: fileName, functionName: functionName, lineNumber: lineNumber
            )
        }
        try closure(returnValue)
    }
}
