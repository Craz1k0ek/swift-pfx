// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-pfx",
    products: [
        .library(
            name: "SwiftPFX",
            targets: ["SwiftPFX"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-asn1.git", .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        .target(
            name: "SwiftPFX",
            dependencies: [
                .product(name: "SwiftASN1", package: "swift-asn1")
            ],
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ]
        ),
        .testTarget(
            name: "SwiftPFXTests",
            dependencies: ["SwiftPFX"]
        )
    ]
)
