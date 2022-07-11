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
        .executable(name: "update", targets: ["UpdateModelsCommand"]),
        .library(
            name: "MacModels",
            targets: ["MacModels"]),
    ],
    dependencies: [
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.2.2")
    ],
    targets: [
        .target(name: "SharedModels"),
        .target(
            name: "MacModels",
            dependencies: ["AppleScraper", "SharedModels"],
            resources: [.copy("Resources/models.json")]
        ),
        .target(
            name: "AppleScraper",
            dependencies: ["SwiftSoup", "SharedModels"]),
        .executableTarget(
            name: "UpdateModelsCommand",
            dependencies: ["AppleScraper"]),
        .testTarget(
            name: "MacModelsTests",
            dependencies: ["MacModels"]),
    ]
)
