// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "ArchitectureKit",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "ArchitectureKit",
            targets: ["ArchitectureKit"]),
    ],
    dependencies: [
        .package(
            url: "git@github.com:IgorShevtshenko/Utils.git",
            .upToNextMajor(from: .init(1, 2, 1))
        ),
    ],
    targets: [
        .target(
            name: "ArchitectureKit",
            dependencies: [
                .product(name: "Utils", package: "Utils")
            ]
        )
    ]
)
