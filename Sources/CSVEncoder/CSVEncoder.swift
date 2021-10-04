// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 04/10/2021.
//  All code (c) 2021 - present day, Elegant Chaos.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public class CSVEncoder: Encoder {
    public var codingPath: [CodingKey] = []
    public var userInfo: [CodingUserInfoKey : Any] = [:]
    internal lazy var dateFormatter: Formatter = makeDateFormatter()
    
    private var data: Data
    private var fields: [String]

    var headers: [String]
    
    enum DateEncodingStrategy {
        case deferredToDate
        case secondsSince1970
        case millisecondsSince1970
        case iso8601
        case custom(DateFormatter)
    }
    
    enum HeaderEncodingStrategy {
        case none
        case auto
        case manual
    }

    var headerEncodingStrategy: HeaderEncodingStrategy
    var dateEncodingStragegy: DateEncodingStrategy

    public static var dateFormatter: Formatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.sss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    public init(headings: [String]? = nil) {
        self.fields = []
        self.data = Data()
        if let headings = headings {
            self.headers = headings
            self.headerEncodingStrategy = headings.count == 0 ? .none : .manual
        } else {
            self.headers = []
            self.headerEncodingStrategy = .auto
        }
        self.dateEncodingStragegy = .deferredToDate
    }
    
    fileprivate func makeDateFormatter() -> Formatter {
        switch dateEncodingStragegy {
            case .deferredToDate:
                return DateFormatter()

            case .iso8601:
                return ISO8601DateFormatter()

            case .custom(let dateFormatter):
                return dateFormatter
                
            default:
                fatalError("No formatter required for this strategy")

        }
    }
    
    public func encode<T: Encodable>(rows: T, headers: [String]? = nil) throws -> Data {
        if let headers = headers {
            self.headers = headers
            self.headerEncodingStrategy = headers.count == 0 ? .none : .manual
        }

        try rows.encode(to: self)
        
        var result = Data()
        
        if headerEncodingStrategy != .none {
            let header = self.headers.joined(separator: ",")
            if let data = "\(header)\n".data(using: .utf8) {
                result.append(data)
            }
        }

        result.append(data)
        return result
    }
    
    func writeDate(_ date: Date) {
        switch dateEncodingStragegy {
            case .deferredToDate:
                writeField((dateFormatter as! DateFormatter).string(from: date))

            case .secondsSince1970:
                writeField("\(Int(date.timeIntervalSince1970))")

            case .millisecondsSince1970:
                writeField("\(Int(date.timeIntervalSince1970 * 1000.0))")

            case .iso8601:
                writeField((dateFormatter as! ISO8601DateFormatter).string(from: date))
                
            case .custom(let formatter):
                writeField(formatter.string(from: date))
        }
    }

    func writeHeader(_ header: String) {
        if headers.contains(header) {
            headerEncodingStrategy = .manual // stop recording headers when we encounter a duplicate, on the assumption that they should be unique
        } else {
            headers.append(header)
        }
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
