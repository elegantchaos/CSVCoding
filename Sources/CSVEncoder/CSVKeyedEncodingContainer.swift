//
//  File.swift
//  
//
//  Created by Sam Deane on 04/10/2021.
//

import Foundation

internal extension CSVEncoder {
    struct CSVKeyedEncodingContainer<K>: KeyedEncodingContainerProtocol where K: CodingKey {
        typealias Key = K
        
        var codingPath: [CodingKey] = []

        private let encoder: CSVEncoder
        
        public init(encoder: CSVEncoder) {
            self.encoder = encoder
        }
        
        mutating func encodeNil(forKey key: K) throws {}
        
        mutating func encode<T>(_ value: T, forKey key: K) throws where T : Encodable {
            if !encoder.gotHeadings {
                if encoder.headings.contains(key.stringValue) {
                    encoder.gotHeadings = true
                } else {
                    encoder.headings.append(key.stringValue)
                }
            }
            if let date = value as? Date {
                encoder.write(encoder.dateFormatter.string(from: date))
            } else if let string = value as? CustomStringConvertible {
                encoder.write(String(describing: string))
            }
            encoder.write(",")
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
}
