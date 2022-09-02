// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 04/10/2021.
//  All code (c) 2021 - present day, Elegant Chaos.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import XCTest
import XCTestExtensions

@testable import CSVCoding

final class CSVEncoderTests: XCTestCase {
    enum TestEnum: Codable {
        case a
        case b
    }
    
    struct Test: Codable {
        let string: String
        let int: Int
        let double: Double
        let bool: Bool
        let date: Date
        let `enum`: TestEnum
        
        internal init(string: String = "String", int: Int = 123, double: Double = 123.456, bool: Bool = true, date: Date = Date(timeIntervalSinceReferenceDate: 0), enum: TestEnum = .a) {
            self.string = string
            self.int = int
            self.double = double
            self.bool = bool
            self.date = date
            self.enum = `enum`
        }
    }
    
    func testAutoHeader() {
        let encoder = CSVEncoder()
        encoder.dateEncodingStragegy = .iso8601
        let data = try! encoder.encode(rows: [Test()])
        let string = String(data: data, encoding: .utf8)!
        XCTAssertEqual(string, """
            string,int,double,bool,date,enum
            String,123,123.456,true,2001-01-01T00:00:00Z,a
            
            """)
    }
    
    func testAutoHeaderMultiple() {
        let encoder = CSVEncoder()
        encoder.dateEncodingStragegy = .iso8601
        let data = try! encoder.encode(rows: [Test(), Test(date: Date(timeIntervalSinceReferenceDate: 1000)), Test(date: Date(timeIntervalSinceReferenceDate: 2000))])
        let string = String(data: data, encoding: .utf8)
        XCTAssertEqual(string, """
            string,int,double,bool,date,enum
            String,123,123.456,true,2001-01-01T00:00:00Z,a
            String,123,123.456,true,2001-01-01T00:16:40Z,a
            String,123,123.456,true,2001-01-01T00:33:20Z,a
            
            """)
    }
    
    func testNoHeader() {
        let encoder = CSVEncoder()
        encoder.dateEncodingStragegy = .iso8601
        encoder.headerEncodingStrategy = .none
        let data = try! encoder.encode(rows: [Test(enum: .b)])
        let string = String(data: data, encoding: .utf8)
        XCTAssertEqual(string, """
            String,123,123.456,true,2001-01-01T00:00:00Z,b
            
            """)
    }
    
    func testManualHeader() {
        let encoder = CSVEncoder()
        encoder.dateEncodingStragegy = .iso8601
        let data = try! encoder.encode(rows: [Test()], headers: ["a", "b", "c", "d", "e", "f"])
        let string = String(data: data, encoding: .utf8)
        XCTAssertEqual(string, """
            a,b,c,d,e,f
            String,123,123.456,true,2001-01-01T00:00:00Z,a
            
            """)
    }

    func testBadHeaderCount() {
        // if we supply the wrong number of headers, the encoder should throw an error
        let encoder = CSVEncoder()
        encoder.dateEncodingStragegy = .iso8601
        XCTAssertThrowsError(try encoder.encode(rows: [Test()], headers: ["a", "b", "c", "d", "e"]))
    }
    
    func testHeaderTranslation() {
        // we're supplying the main bundle to use for localization of the header
        // it doesn't actually contain a translation in this case - so we should end up seeing the raw keys
        let encoder = CSVEncoder(translator: CSVHeaderTranslator())
        encoder.dateEncodingStragegy = .iso8601
        let data = try! encoder.encode(rows: [Test()])
        let string = String(data: data, encoding: .utf8)!
        XCTAssertEqual(string, """
            csv.header.string,csv.header.int,csv.header.double,csv.header.bool,csv.header.date,csv.header.enum
            String,123,123.456,true,2001-01-01T00:00:00Z,a
            
            """)
    }
    
    func testHeaderTranslationCustomPrefix() {
        // we're supplying the main bundle to use for localization of the header
        // it doesn't actually contain a translation in this case - so we should end up seeing the raw keys
        let encoder = CSVEncoder(translator: CSVHeaderTranslator(prefix: "wibble"))
        encoder.dateEncodingStragegy = .iso8601
        let data = try! encoder.encode(rows: [Test()])
        let string = String(data: data, encoding: .utf8)!
        XCTAssertEqual(string, """
            wibble.string,wibble.int,wibble.double,wibble.bool,wibble.date,wibble.enum
            String,123,123.456,true,2001-01-01T00:00:00Z,a
            
            """)
    }
}
