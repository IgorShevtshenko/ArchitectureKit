// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "ArchitectureKit",
    platforms: [.iOS(.v17), .macOS(.v10_15)],
    products: [
        .library(
            name: "ArchitectureKit",
            targets: ["ArchitectureKit"]),
    ],
    dependencies: [
        .package(path: "../Utils"),
    ],
    targets: [
        .target(
            name: "ArchitectureKit",
            dependencies: ["Utils"]
        ),
        .testTarget(
            name: "ArchitectureKitTests",
            dependencies: ["ArchitectureKit"]),
    ]
)
