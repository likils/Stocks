// swift-tools-version:5.5

import PackageDescription

// Swift Package Manager — Package
// @link https://docs.swift.org/package-manager/PackageDescription/PackageDescription.html

let package = Package(
    name: "Persistence",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "StocksPersistence",
            type: .static,
            targets: [
                "StocksPersistence"
            ]
        ),
    ],
    dependencies: [
        .package(
            name: "Data",
            path: "../Data"
        ),
    ],
    targets: [
        .target(
            name: "StocksPersistence",
            dependencies: [
                .product(name: "StocksData", package: "Data"),
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "StocksPersistence.UnitTests",
            dependencies: [
                "StocksPersistence"
            ],
            path: "Tests"
        ),
    ],
    swiftLanguageVersions: [.v5]
)
