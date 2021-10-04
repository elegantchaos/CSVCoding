// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 04/10/2021.
//  All code (c) 2021 - present day, Elegant Chaos.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import XCTest
import XCTestExtensions

@testable import CSVEncoder

final class CSVEncoderTests: XCTestCase {
    func testExample() {
        struct Test: Codable {
            var string = "String"
            var int = 123
            var double = 123.456
            var bool = true
            var date = Date(timeIntervalSinceReferenceDate: 0)
        }
        
        let encoder = CSVEncoder()
        let data = try! encoder.encode(rows: [Test()])
        let string = String(data: data, encoding: .utf8)
        XCTAssertEqual(string, "String,123,123.456,true,2001-01-01 00:00:00.000,\n")
    }
}
