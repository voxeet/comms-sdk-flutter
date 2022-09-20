import Foundation

protocol FlutterConvertible {
    static func fromFlutterValue(_ value: Any) throws -> Self
    func toFlutterValue() -> Any
}

class FlutterValueEncoder: Encoder {
        
    private struct FKeyedEncodingContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {

        var encoder: FlutterValueEncoder

        var codingPath: [CodingKey] = []
        
        init(encoder: FlutterValueEncoder) {
            encoder.keyedStorage = [:]
            self.encoder = encoder
        }

        mutating func nestedContainer<NestedKey>(
            keyedBy keyType: NestedKey.Type,
            forKey key: Key
        ) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
            return encoder.container(keyedBy: keyType)
        }
        
        mutating func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
            return encoder.unkeyedContainer()
        }
        
        mutating func superEncoder() -> Encoder {
            return encoder
        }
        
        mutating func superEncoder(forKey key: Key) -> Encoder {
            return encoder
        }

        mutating func encodeNil(forKey key: Key) throws {
            guard encoder.keyedStorage != nil else {
                throw EncoderError.notExist()
            }
            encoder.keyedStorage?[key.stringValue] = NSNull()
        }
        
        mutating func encode(_ value: Bool, forKey key: Key) throws { try store(fc: value, k: key) }
        mutating func encode(_ value: String, forKey key: Key) throws { try store(fc: value, k: key) }
        mutating func encode(_ value: Double, forKey key: Key) throws { try store(fc: value, k: key) }
        mutating func encode(_ value: Float, forKey key: Key) throws { try store(fc: value, k: key) }
        mutating func encode(_ value: Int, forKey key: Key) throws { try store(fc: value, k: key) }
        mutating func encode(_ value: Int8, forKey key: Key) throws { try store(fc: value, k: key) }
        mutating func encode(_ value: Int16, forKey key: Key) throws { try store(fc: value, k: key) }
        mutating func encode(_ value: Int32, forKey key: Key) throws { try store(fc: value, k: key) }
        mutating func encode(_ value: Int64, forKey key: Key) throws { try store(fc: value, k: key) }
        mutating func encode(_ value: UInt, forKey key: Key) throws { try store(fc: value, k: key) }
        mutating func encode(_ value: UInt8, forKey key: Key) throws { try store(fc: value, k: key) }
        mutating func encode(_ value: UInt16, forKey key: Key) throws { try store(fc: value, k: key) }
        mutating func encode(_ value: UInt32, forKey key: Key) throws { try store(fc: value, k: key) }
        mutating func encode(_ value: UInt64, forKey key: Key) throws { try store(fc: value, k: key) }
        
        mutating func encode<T>(_ value: T, forKey key: Key) throws where T : Encodable {
            let enc = FlutterValueEncoder()
            try value.encode(to: enc)
            try store(v: enc.storage(), k: key)
        }

        mutating func encodeConditional<T>(
            _ object: T,
            forKey key: Key
        ) throws where T : AnyObject, T : Encodable {
            let enc = FlutterValueEncoder()
            try object.encode(to: enc)
            try store(v: enc.storage(), k: key)
        }

        private func store(v value: Any?, k key: Key) throws -> Void {
            guard encoder.keyedStorage != nil else {
                throw EncoderError.notExist()
            }
            encoder.keyedStorage?[key.stringValue] = value
        }

        private func store(fc flutterConvertible: FlutterConvertible?, k key: Key) throws {
            try store(v: flutterConvertible?.toFlutterValue(), k: key)
        }
    }
    
    private struct FUnkeyedEncodingContainer: UnkeyedEncodingContainer {
        
        let encoder: FlutterValueEncoder
                
        var codingPath: [CodingKey] = []
        
        var count: Int = 0
        
        init(encoder: FlutterValueEncoder) {
            encoder.unkeyedStorage = []
            self.encoder = encoder
        }
        
        func nestedContainer<NestedKey>(
            keyedBy keyType: NestedKey.Type
        ) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
            return encoder.container(keyedBy: keyType)
        }
        
        func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
            return encoder.unkeyedContainer()
        }
        
        func superEncoder() -> Encoder {
            return encoder
        }
        
        mutating func encodeNil() throws {
            guard encoder.unkeyedStorage != nil else {
                throw EncoderError.notExist()
            }
            encoder.unkeyedStorage?.append(NSNull())

        }

        mutating func encode(_ value: Bool) throws { try store(fc: value) }
        mutating func encode(_ value: String) throws { try store(fc: value) }
        mutating func encode(_ value: Double) throws { try store(fc: value) }
        mutating func encode(_ value: Float) throws { try store(fc: value) }
        mutating func encode(_ value: Int) throws { try store(fc: value) }
        mutating func encode(_ value: Int8) throws { try store(fc: value) }
        mutating func encode(_ value: Int16) throws { try store(fc: value) }
        mutating func encode(_ value: Int32) throws { try store(fc: value) }
        mutating func encode(_ value: Int64) throws { try store(fc: value) }
        mutating func encode(_ value: UInt) throws { try store(fc: value) }
        mutating func encode(_ value: UInt8) throws { try store(fc: value) }
        mutating func encode(_ value: UInt16) throws { try store(fc: value) }
        mutating func encode(_ value: UInt32) throws { try store(fc: value) }
        mutating func encode(_ value: UInt64) throws { try store(fc: value) }

        mutating func encode<T>(_ value: T) throws where T : Encodable {
            let enc = FlutterValueEncoder()
            try value.encode(to: enc)
            try store(v: enc.storage())
        }
        
        private func store(v value: Any) throws {
            guard encoder.unkeyedStorage != nil else {
                throw EncoderError.notExist()
            }
            encoder.unkeyedStorage?.append(value)
        }
        
        private func store(fc flutterConvertible: FlutterConvertible) throws -> Void {
            try store(v: flutterConvertible.toFlutterValue())
        }
    }
    
    private struct FSingleValueEncodingContainer: SingleValueEncodingContainer {
        
        let encoder: FlutterValueEncoder
        
        var codingPath: [CodingKey] = []
        
        init(encoder: FlutterValueEncoder) {
            self.encoder = encoder
        }

        mutating func encodeNil() throws {
            encoder.singleValueStorage = NSNull()
        }

        mutating func encode(_ value: Bool) throws { store(fc: value) }
        mutating func encode(_ value: String) throws { store(fc: value) }
        mutating func encode(_ value: Double) throws { store(fc: value) }
        mutating func encode(_ value: Float) throws { store(fc: value) }
        mutating func encode(_ value: Int) throws { store(fc: value) }
        mutating func encode(_ value: Int8) throws { store(fc: value) }
        mutating func encode(_ value: Int16) throws { store(fc: value) }
        mutating func encode(_ value: Int32) throws { store(fc: value) }
        mutating func encode(_ value: Int64) throws { store(fc: value) }
        mutating func encode(_ value: UInt) throws { store(fc: value) }
        mutating func encode(_ value: UInt8) throws { store(fc: value) }
        mutating func encode(_ value: UInt16) throws { store(fc: value) }
        mutating func encode(_ value: UInt32) throws { store(fc: value) }
        mutating func encode(_ value: UInt64) throws { store(fc: value) }
        
        mutating func encode<T>(_ value: T) throws where T : Encodable {
            let enc = FlutterValueEncoder()
            try value.encode(to: enc)
            store(v: try enc.storage())
        }
        
        private func store(fc flutterConvertible: FlutterConvertible) {
            store(v: flutterConvertible.toFlutterValue())
        }
        
        private func store(v value: Any) {
            encoder.singleValueStorage = value
        }
    }
    
    var codingPath: [CodingKey] = []
    
    var userInfo: [CodingUserInfoKey : Any] = [:]
    
    
    fileprivate(set) var keyedStorage: [String: Any]?
    
    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        return KeyedEncodingContainer<Key>(FKeyedEncodingContainer<Key>(encoder: self))
    }
    
    fileprivate(set) var unkeyedStorage: [Any]?
    
    func unkeyedContainer() -> UnkeyedEncodingContainer {
        return FUnkeyedEncodingContainer(encoder: self)
    }
    
    fileprivate(set) var singleValueStorage: Any?
    func singleValueContainer() -> SingleValueEncodingContainer {
        return FSingleValueEncodingContainer(encoder: self)
    }
    
    func storage() throws -> Any {
        if let s = keyedStorage {
            return s
        }
        if let s = unkeyedStorage {
            return s
        }
        if let s = singleValueStorage {
            return s
        }
        throw EncoderError.storageFailed()
    }
    
    func encode<T: Encodable>(e: T) throws -> Any {
        try e.encode(to: self)
        return try storage()
    }
    
}

class FlutterValueDecoder: Decoder {

    private struct FKeyedDecodingContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
        
        
        let decoder: FlutterValueDecoder
        
        let codingPath: [CodingKey] = []

        func nestedContainer<NestedKey>(
            keyedBy type: NestedKey.Type,
            forKey key: Key
        ) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
            return try decoder.container(keyedBy: type)
        }
        
        func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
            return try decoder.unkeyedContainer()
        }
        
        func superDecoder() throws -> Decoder {
            return decoder
        }
        
        func superDecoder(forKey key: Key) throws -> Decoder {
            return decoder
        }
        
        let allKeys: [Key] = []

        func contains(_ key: Key) -> Bool { return true }

        func decodeNil(forKey key: Key) throws -> Bool {
            guard
                let storage = decoder.keyedStorage
            else {
                throw EncoderError.notExist()
            }
            return storage[key.stringValue] == nil || storage[key.stringValue] is NSNull
        }
        
        func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool  { try read(k: key) }
        func decode(_ type: String.Type, forKey key: Key) throws -> String { try read(k: key) }
        func decode(_ type: Double.Type, forKey key: Key) throws -> Double { try read(k: key) }
        func decode(_ type: Float.Type, forKey key: Key) throws -> Float { try read(k: key) }
        func decode(_ type: Int.Type, forKey key: Key) throws -> Int { try read(k: key) }
        func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 { try read(k: key) }
        func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 { try read(k: key) }
        func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 { try read(k: key) }
        func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 { try read(k: key) }
        func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt { try read(k: key) }
        func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 { try read(k: key) }
        func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 { try read(k: key) }
        func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 { try read(k: key) }
        func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 { try read(k: key) }
        
        func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
            let dec = FlutterValueDecoder(value: try readValue(k: key))
            return try type.init(from: dec)
        }
        
        private func readValue(k: Key) throws -> Any {
            guard
                let storage = decoder.keyedStorage,
                let value = storage[k.stringValue]
            else {
                throw EncoderError.notExist()
            }
            return value
        }
        
        private func read<T: FlutterConvertible>(k: Key) throws -> T {
            return try T.fromFlutterValue(try readValue(k: k))
        }
    }
    
    struct FUnkeyedDecodingContainer: UnkeyedDecodingContainer {
        
        let decoder: FlutterValueDecoder
        
        let  codingPath: [CodingKey] = []
        
        var count: Int? { decoder.unkeyedStorage?.count }
        
        var isAtEnd: Bool {
            guard let count = count else {
                return true
            }
            return currentIndex >= count
        }
        
        var currentIndex: Int = 0
        
        mutating func nestedContainer<NestedKey>(
            keyedBy type: NestedKey.Type
        ) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
            return try decoder.container(keyedBy: type)
        }
        
        mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
            return try decoder.unkeyedContainer()
        }
        
        mutating func superDecoder() throws -> Decoder {
            return decoder
        }
        
        mutating func decodeNil() throws -> Bool {
            guard
                let storage = decoder.unkeyedStorage,
                !isAtEnd
            else {
                throw EncoderError.notExist()
            }
            return storage[currentIndex] is NSNull
        }
        
        mutating func decode(_ type: Bool.Type) throws -> Bool { try read() }
        mutating func decode(_ type: String.Type) throws -> String { try read() }
        mutating func decode(_ type: Double.Type) throws -> Double { try read() }
        mutating func decode(_ type: Float.Type) throws -> Float { try read() }
        mutating func decode(_ type: Int.Type) throws -> Int { try read() }
        mutating func decode(_ type: Int8.Type) throws -> Int8 { try read() }
        mutating func decode(_ type: Int16.Type) throws -> Int16 { try read() }
        mutating func decode(_ type: Int32.Type) throws -> Int32 { try read() }
        mutating func decode(_ type: Int64.Type) throws -> Int64 { try read() }
        mutating func decode(_ type: UInt.Type) throws -> UInt { try read() }
        mutating func decode(_ type: UInt8.Type) throws -> UInt8 { try read() }
        mutating func decode(_ type: UInt16.Type) throws -> UInt16 { try read() }
        mutating func decode(_ type: UInt32.Type) throws -> UInt32 { try read() }
        mutating func decode(_ type: UInt64.Type) throws -> UInt64 { try read() }
        
        mutating func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
            let dec = FlutterValueDecoder(value: try readValue())
            return try type.init(from: dec)
        }

        private mutating func readValue() throws -> Any {
            defer {
                currentIndex += 1
            }
            guard
                let storage = decoder.unkeyedStorage,
                !isAtEnd
            else {
                throw EncoderError.notExist()
            }
            return storage[currentIndex]
        }
        
        private mutating func read<T: FlutterConvertible>() throws -> T {
            return try T.fromFlutterValue(try readValue())
        }
    }
    
    struct FSingleValueDecodingContainer: SingleValueDecodingContainer {
        
        let decoder: FlutterValueDecoder
        
        let codingPath: [CodingKey] = []
        
        func decodeNil() -> Bool {
            return decoder.singleValueStorage == nil || decoder.singleValueStorage is NSNull
        }
        
        func decode(_ type: Bool.Type) throws -> Bool { try read() }
        func decode(_ type: String.Type) throws -> String { try read() }
        func decode(_ type: Double.Type) throws -> Double { try read() }
        func decode(_ type: Float.Type) throws -> Float { try read() }
        func decode(_ type: Int.Type) throws -> Int { try read() }
        func decode(_ type: Int8.Type) throws -> Int8 { try read() }
        func decode(_ type: Int16.Type) throws -> Int16 { try read() }
        func decode(_ type: Int32.Type) throws -> Int32 { try read() }
        func decode(_ type: Int64.Type) throws -> Int64 { try read() }
        func decode(_ type: UInt.Type) throws -> UInt { try read() }
        func decode(_ type: UInt8.Type) throws -> UInt8 { try read() }
        func decode(_ type: UInt16.Type) throws -> UInt16 { try read() }
        func decode(_ type: UInt32.Type) throws -> UInt32 { try read() }
        func decode(_ type: UInt64.Type) throws -> UInt64 { try read() }
        
        func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
            let dec = FlutterValueDecoder(value: try readValue())
            return try type.init(from: dec)
        }
        
        private func readValue() throws -> Any {
            guard
                let storage = decoder.singleValueStorage
            else {
                throw EncoderError.notExist()
            }
            return storage
        }
        
        private func read<T: FlutterConvertible>() throws -> T {
            return try T.fromFlutterValue(readValue())
        }
        
    }
    
    
    var codingPath: [CodingKey] = []
    
    var userInfo: [CodingUserInfoKey : Any] = [:]
    
    
    init(value: Any) {
        if let d = value as? [String: Any] {
            keyedStorage = d
        } else if let a = value as? [Any] {
            unkeyedStorage = a
        } else {
            singleValueStorage = value
        }
    }
    
    func decode<T: Decodable>(type: T.Type) throws -> T {
        return try T(from: self)
    }
    
    fileprivate var keyedStorage: [String: Any]? = nil
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        return KeyedDecodingContainer<Key>(FKeyedDecodingContainer(decoder: self))
    }
    
    fileprivate var unkeyedStorage: [Any]? = nil
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        return FUnkeyedDecodingContainer(decoder: self)
    }
    
    fileprivate var singleValueStorage: Any? = nil
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        return FSingleValueDecodingContainer(decoder: self)
    }
    
    
}

extension String: FlutterConvertible {
    static func fromFlutterValue(_ value: Any) throws -> String {
        guard let str = value as? String else {
            throw EncoderError.castingToStringFailed()
        }
        return str
    }
    func toFlutterValue() -> Any { self }
}

extension Bool: FlutterConvertible {
    static func fromFlutterValue(_ value: Any) throws -> Bool {
        guard let num = value as? NSNumber else {
            throw EncoderError.castingToNumberFailed()
        }
        return num.boolValue
    }
    func toFlutterValue() -> Any { NSNumber(value: self) }
}

extension Double: FlutterConvertible {
    static func fromFlutterValue(_ value: Any) throws -> Double {
        guard let num = value as? NSNumber else {
            throw EncoderError.castingToNumberFailed()
        }
        return num.doubleValue
    }
    func toFlutterValue() -> Any { NSNumber(value: self) }
}

extension Float: FlutterConvertible {
    static func fromFlutterValue(_ value: Any) throws -> Float {
        guard let num = value as? NSNumber else {
            throw EncoderError.castingToNumberFailed()
        }
        return num.floatValue
    }
    func toFlutterValue() -> Any { NSNumber(value: self) }
}

extension Int: FlutterConvertible {
    static func fromFlutterValue(_ value: Any) throws -> Int {
        guard let num = value as? NSNumber else {
            throw EncoderError.castingToNumberFailed()
        }
        return num.intValue
    }
    func toFlutterValue() -> Any { NSNumber(value: self) }
}

extension Int8: FlutterConvertible {
    static func fromFlutterValue(_ value: Any) throws -> Int8 {
        guard let num = value as? NSNumber else {
            throw EncoderError.castingToNumberFailed()
        }
        return num.int8Value
    }
    func toFlutterValue() -> Any { NSNumber(value: self) }
}

extension Int16: FlutterConvertible {
    static func fromFlutterValue(_ value: Any) throws -> Int16 {
        guard let num = value as? NSNumber else {
            throw EncoderError.castingToNumberFailed()
        }
        return num.int16Value
    }
    func toFlutterValue() -> Any { NSNumber(value: self) }
}

extension Int32: FlutterConvertible {
    static func fromFlutterValue(_ value: Any) throws -> Int32 {
        guard let num = value as? NSNumber else {
            throw EncoderError.castingToNumberFailed()
        }
        return num.int32Value
    }
    func toFlutterValue() -> Any { NSNumber(value: self) }
}

extension Int64: FlutterConvertible {
    static func fromFlutterValue(_ value: Any) throws -> Int64 {
        guard let num = value as? NSNumber else {
            throw EncoderError.castingToNumberFailed()
        }
        return num.int64Value
    }
    func toFlutterValue() -> Any { NSNumber(value: self) }
}

extension UInt: FlutterConvertible {
    static func fromFlutterValue(_ value: Any) throws -> UInt {
        guard let num = value as? NSNumber else {
            throw EncoderError.castingToNumberFailed()
        }
        return num.uintValue
    }
    func toFlutterValue() -> Any { NSNumber(value: self) }
}

extension UInt8: FlutterConvertible {
    static func fromFlutterValue(_ value: Any) throws -> UInt8 {
        guard let num = value as? NSNumber else {
            throw EncoderError.castingToNumberFailed()
        }
        return num.uint8Value
    }
    func toFlutterValue() -> Any { NSNumber(value: self) }
}

extension UInt16: FlutterConvertible {
    static func fromFlutterValue(_ value: Any) throws -> UInt16 {
        guard let num = value as? NSNumber else {
            throw EncoderError.castingToNumberFailed()
        }
        return num.uint16Value
    }
    func toFlutterValue() -> Any { NSNumber(value: self) }
}

extension UInt32: FlutterConvertible {
    static func fromFlutterValue(_ value: Any) throws -> UInt32 {
        guard let num = value as? NSNumber else {
            throw EncoderError.castingToNumberFailed()
        }
        return num.uint32Value
    }
    func toFlutterValue() -> Any { NSNumber(value: self) }
}

extension UInt64: FlutterConvertible {
    static func fromFlutterValue(_ value: Any) throws -> UInt64 {
        guard let num = value as? NSNumber else {
            throw EncoderError.castingToNumberFailed()
        }
        return num.uint64Value
    }
    func toFlutterValue() -> Any { NSNumber(value: self) }
}
