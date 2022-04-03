// swift-tools-version:5.5

import PackageDescription

// Swift Package Manager — Package
// @link https://docs.swift.org/package-manager/PackageDescription/PackageDescription.html

let package = Package(
    name: "Data",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "StocksData",
            type: .static,
            targets: [
                "StocksData"
            ]
        ),
    ],
    dependencies: [
        .package(
            name: "System",
            path: "../System"
        ),
        .package(
            url: "https://github.com/GottaGetSwifty/CodableWrappers",
            .upToNextMajor(from: "2.0.0")
        ),
    ],
    targets: [
        .target(
            name: "StocksData",
            dependencies: [
                .product(name: "StocksSystem", package: "System"),
                .byName(name: "CodableWrappers"),
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "StocksData.UnitTests",
            dependencies: [
                "StocksData"
            ],
            path: "Tests"
        ),
    ],
    swiftLanguageVersions: [.v5]
)
