// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 04/10/2021.
//  All code (c) 2021 - present day, Elegant Chaos.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import XCTest
import XCTestExtensions

@testable import CSVEncoder

final class CSVEncoderTests: XCTestCase {
    struct Test: Codable {
        let string: String
        let int: Int
        let double: Double
        let bool: Bool
        let date: Date

        internal init(string: String = "String", int: Int = 123, double: Double = 123.456, bool: Bool = true, date: Date = Date(timeIntervalSinceReferenceDate: 0)) {
            self.string = string
            self.int = int
            self.double = double
            self.bool = bool
            self.date = date
        }
    }

    func testAutoHeader() {
        let encoder = CSVEncoder()
        encoder.dateEncodingStragegy = .iso8601
        let data = try! encoder.encode(rows: [Test()])
        let string = String(data: data, encoding: .utf8)
        XCTAssertEqual(string, """
            string,int,double,bool,date
            String,123,123.456,true,2001-01-01T00:00:00Z

            """)
    }

    func testAutoHeaderMultiple() {
        let encoder = CSVEncoder()
        encoder.dateEncodingStragegy = .iso8601
        let data = try! encoder.encode(rows: [Test(), Test(date: Date(timeIntervalSinceReferenceDate: 1000)), Test(date: Date(timeIntervalSinceReferenceDate: 2000))])
        let string = String(data: data, encoding: .utf8)
        XCTAssertEqual(string, """
            string,int,double,bool,date
            String,123,123.456,true,2001-01-01T00:00:00Z
            String,123,123.456,true,2001-01-01T00:16:40Z
            String,123,123.456,true,2001-01-01T00:33:20Z
            
            """)
    }

    func testNoHeader() {
        let encoder = CSVEncoder()
        encoder.dateEncodingStragegy = .iso8601
        encoder.headerEncodingStrategy = .none
        let data = try! encoder.encode(rows: [Test()])
        let string = String(data: data, encoding: .utf8)
        XCTAssertEqual(string, """
            String,123,123.456,true,2001-01-01T00:00:00Z

            """)
    }

    func testManualHeader() {
        let encoder = CSVEncoder()
        encoder.dateEncodingStragegy = .iso8601
        let data = try! encoder.encode(rows: [Test()], headers: ["a", "b", "c", "d", "e"])
        let string = String(data: data, encoding: .utf8)
        XCTAssertEqual(string, """
            a,b,c,d,e
            String,123,123.456,true,2001-01-01T00:00:00Z

            """)
    }

}
