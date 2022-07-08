// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "MacModels",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .macCatalyst(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "MacModels",
            targets: ["MacModels"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "MacModels",
            dependencies: [],
            resources: [
                .copy("Resources/models.json")
            ]
        ),
        .testTarget(
            name: "MacModelsTests",
            dependencies: ["MacModels"]),
    ]
)
