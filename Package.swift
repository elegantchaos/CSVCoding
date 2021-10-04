// swift-tools-version:5.3

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 04/10/2021.
//  All code (c) 2021 - present day, Elegant Chaos.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import PackageDescription

let package = Package(
    name: "CSVEncoder",
    platforms: [
        .macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)
    ],
    products: [
        .library(
            name: "CSVEncoder",
            targets: ["CSVEncoder"]),
    ],
    dependencies: [
        .package(url: "https://github.com/elegantchaos/XCTestExtensions.git", from: "1.3.3")
    ],
    targets: [
        .target(
            name: "CSVEncoder",
            dependencies: []),
        .testTarget(
            name: "CSVEncoderTests",
            dependencies: ["CSVEncoder", "XCTestExtensions"]),
    ]
)
