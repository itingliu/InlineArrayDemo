// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "InlineArrayDemo",
    platforms: [.macOS("26.0")],
    products: [
        .library(name: "StringData", targets: ["StringData"]),
    ],
    targets: [
        .target(name: "CStringData"),
        .target(
            name: "Essentials",
            dependencies: ["StringData"],
            swiftSettings: [
                .enableExperimentalFeature("Lifetimes"),
            ]
        ),
        .target(
            name: "StringData",
            dependencies: ["CStringData"],
            swiftSettings: [
                .enableExperimentalFeature("Lifetimes"),
            ]
        ),
        .executableTarget(
            name: "Demo",
            dependencies: ["Essentials"]
        ),
    ]
)
