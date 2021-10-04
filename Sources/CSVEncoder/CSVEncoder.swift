// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 04/10/2021.
//  All code (c) 2021 - present day, Elegant Chaos.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public class CSVEncoder: Encoder {
    public var codingPath: [CodingKey] = []
    public var userInfo: [CodingUserInfoKey : Any] = [:]
    internal let dateFormatter: DateFormatter
    
    private var data = Data()
    var headings: [String] = []
    var gotHeadings = false

    public static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.sss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    public init(dateFormatter: DateFormatter = CSVEncoder.dateFormatter) {
        self.dateFormatter = dateFormatter
    }
    
    public func encode<T: Encodable>(rows: T) throws -> Data {
        try rows.encode(to: self)
        
        
        var result = Data()
        if headings.count > 0 {
            let header = self.headings.joined(separator: ",")
            if let data = "\(header)\n".data(using: .utf8) {
                result.append(data)
            }
        }

        result.append(data)
        return result
    }
    
    func write(_ string: String) {
        data.append(string.data(using: .utf8)!)
    }
    
    public func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        return KeyedEncodingContainer(CSVKeyedEncodingContainer<Key>(encoder: self))
    }
    
    public func unkeyedContainer() -> UnkeyedEncodingContainer {
        return CSVUnkeyedEncodingContainer(encoder: self)
    }
    
    public func singleValueContainer() -> SingleValueEncodingContainer {
        return self as! SingleValueEncodingContainer
    }
    
    
    private struct CSVUnkeyedEncodingContainer: UnkeyedEncodingContainer {
        
        var codingPath: [CodingKey] = []
        var count: Int = 0
        
        private let encoder: CSVEncoder
        
        init(encoder: CSVEncoder) {
            self.encoder = encoder
        }
        
        mutating func encode<T>(_ value: T) throws where T : Encodable {
            try value.encode(to: encoder)
            encoder.write("\n")
            count += 1
        }
        
        mutating func encodeNil() throws {
        }
        
        mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
            return encoder.container(keyedBy: keyType)
        }
        
        mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
            return self
        }
        
        mutating func superEncoder() -> Encoder {
            return encoder
        }
        
    }
    
}
