// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "MacModels",
    products: [
        .library(
            name: "MacModels",
            targets: ["MacModels"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "MacModels",
            dependencies: []),
        .testTarget(
            name: "MacModelsTests",
            dependencies: ["MacModels"]),
    ]
)
