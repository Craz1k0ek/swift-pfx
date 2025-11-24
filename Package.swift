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
    targets: [
        .target(
            name: "SwiftPFX",
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
