// swift-tools-version:5.5

import PackageDescription

// Swift Package Manager — Package
// @link https://docs.swift.org/package-manager/PackageDescription/PackageDescription.html

import PackageDescription

let package = Package(
    name: "System",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "StocksSystem",
            type: .static,
            targets: [
                "StocksSystem"
            ]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/hmlongco/Resolver",
            .upToNextMajor(from: "1.5.0")
        ),
    ],
    targets: [
        .target(
            name: "StocksSystem",
            dependencies: [
                .byName(name: "Resolver"),
            ],
            path: "Sources"
        ),
    ],
    swiftLanguageVersions: [.v5]
)
