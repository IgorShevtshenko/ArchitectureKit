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
        .package(
            url: "git@github.com:IgorShevtshenko/Utils.git",
            .upToNextMajor(from: .init(1, 1, 1))
        ),
    ],
    targets: [
        .target(
            name: "ArchitectureKit",
            dependencies: [
                .product(name: "Utils", package: "Utils")
            ]
        ),
        .testTarget(
            name: "ArchitectureKitTests",
            dependencies: ["ArchitectureKit"]),
    ]
)
