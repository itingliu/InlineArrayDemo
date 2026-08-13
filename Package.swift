// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "InlineArrayDemo",
    platforms: [.macOS("26.0")],
    products: [
        .library(name: "CListFormatData", targets: ["CListFormatData"]),
    ],
    targets: [
        .target(name: "CListFormatData"),
        .target(
            name: "ListFormatDataC",
            dependencies: ["CListFormatData"],
            swiftSettings: [
                .enableExperimentalFeature("Lifetimes"),
            ]
        ),
        .target(
            name: "ListFormatData",
            swiftSettings: [
                .enableExperimentalFeature("Lifetimes"),
            ]
        ),
        .executableTarget(
            name: "DemoListFormatC",
            dependencies: ["ListFormatDataC"],
            swiftSettings: [
                .enableExperimentalFeature("Lifetimes"),
            ]
        ),
        .executableTarget(
            name: "DemoListFormatInlineArray",
            dependencies: ["ListFormatData"],
            swiftSettings: [
                .enableExperimentalFeature("Lifetimes"),
            ]
        ),
    ]
)
