// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 02/09/22.
//  All code (c) 2022 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

/// Helper which looks up header names with NSLocalizedString.
public struct CSVHeaderTranslator {
    let bundle: Bundle
    let tableName: String?
    let prefix: String
    
    public init(bundle: Bundle = Bundle.main, tableName: String? = nil, prefix: String = "csv.header") {
        self.bundle = bundle
        self.tableName = tableName
        self.prefix = prefix
    }
    
    func translate(_ headers: [String]) -> [String] {
        return headers.map { NSLocalizedString("\(prefix).\($0)", tableName: tableName, bundle: bundle, comment: "")}
    }
}
