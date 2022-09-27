import Foundation

internal enum EncoderError: Error {
    case notImplemented(file: String = #filePath, lineNumber: Int = #line)
    case notExist(file: String = #filePath, lineNumber: Int = #line)
    case notArray(file: String = #filePath, lineNumber: Int = #line)
    case notDictionary(file: String = #filePath, lineNumber: Int = #line)
    case outOfRange(file: String = #filePath, lineNumber: Int = #line)
    case decoderFailed(file: String = #filePath, lineNumber: Int = #line)
    case encoderFailed(file: String = #filePath, lineNumber: Int = #line)
    case storageFailed(file: String = #filePath, lineNumber: Int = #line)
    case castingToStringFailed(file: String = #filePath, lineNumber: Int = #line)
    case castingToNumberFailed(file: String = #filePath, lineNumber: Int = #line)
    case createObjectFailed(file: String = #filePath, lineNumber: Int = #line)
    case keyNotFound(value: String, file: String = #filePath, lineNumber: Int = #line)
}

extension EncoderError: LocalizedError {
    var localizedDescription: String? {
        switch self {
        case let .notImplemented(file, lineNumber):
            return "Not implemented.".addErrorLocation(file, lineNumber)
        case let .notExist(file, lineNumber):
            return "Element doesn't exist.".addErrorLocation(file, lineNumber)
        case let .notArray(file, lineNumber):
            return "Element is not an array.".addErrorLocation(file, lineNumber)
        case let .outOfRange(file, lineNumber):
            return "Index out of range.".addErrorLocation(file, lineNumber)
        case let .notDictionary(file, lineNumber):
            return "Element is not a dictionary.".addErrorLocation(file, lineNumber)
        case let .decoderFailed(file, lineNumber):
            return "Decoder failed.".addErrorLocation(file, lineNumber)
        case let .encoderFailed(file, lineNumber):
            return "Encoder failed.".addErrorLocation(file, lineNumber)
        case let .storageFailed(file, lineNumber):
            return "Storage failed.".addErrorLocation(file, lineNumber)
        case let .castingToStringFailed(file, lineNumber):
            return "Casting to String failed.".addErrorLocation(file, lineNumber)
        case let .castingToNumberFailed(file, lineNumber):
            return "Casting to NSNumber failed.".addErrorLocation(file, lineNumber)
        case let .createObjectFailed(file, lineNumber):
            return "Failed to create an object.".addErrorLocation(file, lineNumber)
        case let .keyNotFound(value, file, lineNumber):
            return "Key not found: \(value)".addErrorLocation(file, lineNumber)
        }
    }
}

func fatalError(error: EncoderError, file: StaticString = #file, line: UInt = #line) -> Never {
    fatalError(error.localizedDescription, file: file, line: line)
}

fileprivate extension String {
    func addErrorLocation(_ file: String, _ lineNumber: Int) -> String {
        return "\(self) Error occured in: '\(file)' at line number: \(lineNumber)"
    }
}
