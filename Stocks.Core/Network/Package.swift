// swift-tools-version:5.5

import PackageDescription

// Swift Package Manager — Package
// @link https://docs.swift.org/package-manager/PackageDescription/PackageDescription.html

let package = Package(
    name: "Network",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "StocksNetwork",
            type: .static,
            targets: [
                "StocksNetwork"
            ]
        ),
    ],
    dependencies: [
        .package(
            name: "Persistence",
            path: "../Persistence"
        ),
    ],
    targets: [
        .target(
            name: "StocksNetwork",
            dependencies: [
                .product(name: "StocksPersistence", package: "Persistence"),
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "StocksNetwork.UnitTests",
            dependencies: [
                "StocksNetwork"
            ],
            path: "Tests"
        ),
    ],
    swiftLanguageVersions: [.v5]
)
