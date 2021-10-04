// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 04/10/2021.
//  All code (c) 2021 - present day, Elegant Chaos.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public class CSVEncoder: Encoder {
    public var codingPath: [CodingKey] = []
    public var userInfo: [CodingUserInfoKey : Any] = [:]
    internal let dateFormatter: DateFormatter
    
    private var data: Data
    var headings: [String]
    var fields: [String]
    
    enum HeadingMode {
        case unfilled
        case filled
    }

    var headingMode: HeadingMode

    public static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.sss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    public init(headings: [String]? = nil, dateFormatter: DateFormatter = CSVEncoder.dateFormatter) {
        self.dateFormatter = dateFormatter
        self.fields = []
        self.data = Data()
        if let headings = headings {
            self.headings = headings
            self.headingMode = .filled
        } else {
            self.headings = []
            self.headingMode = .unfilled
        }
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
    
    func writeField(_ field: String) {
        fields.append(field)
    }

    func writeRecord() {
        let line = fields.joined(separator: ",")
        data.append("\(line)\n".data(using: .utf8)!)
        fields = []
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
    
    
    
}
