// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 04/10/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

struct CSVKeyedEncodingContainer<K>: KeyedEncodingContainerProtocol where K: CodingKey {
    typealias Key = K
    
    var codingPath: [CodingKey] = []
    
    private let encoder: CSVEncoder
    
    public init(encoder: CSVEncoder) {
        self.encoder = encoder
    }
    
    mutating func encodeNil(forKey key: K) throws {
        if encoder.headerEncodingStrategy == .auto {
            encoder.writeHeader(key.stringValue)
        }
        
        encoder.writeField("")
    }
    
    mutating func encode<T>(_ value: T, forKey key: K) throws where T : Encodable {
        if encoder.headerEncodingStrategy == .auto {
            encoder.writeHeader(key.stringValue)
        }
        
        if let date = value as? Date {
            encoder.writeDate(date)
        } else {
            encoder.writeField(String(describing: value))
        }
    }
    
    mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: K) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        return encoder.container(keyedBy: keyType)
    }
    
    mutating func nestedUnkeyedContainer(forKey key: K) -> UnkeyedEncodingContainer {
        return encoder.unkeyedContainer()
    }
    
    mutating func superEncoder() -> Encoder {
        return encoder
    }
    
    mutating func superEncoder(forKey key: K) -> Encoder {
        return encoder
    }
    
}
