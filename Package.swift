// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Favorite",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "Favorite", targets: ["Favorite"]),
    ],
    dependencies: [
        .package(url: "https://github.com/adedwi1808/game-catalogue-Core-package.git", from: "1.0.1"),
        .package(url: "https://github.com/adedwi1808/game-catalogue-Common-package.git", from: "1.0.1"),
        .package(url: "https://github.com/adedwi1808/game-catalogue-Components-package.git", from: "1.0.1"),
        .package(url: "https://github.com/adedwi1808/game-catalogue-GameDetail-package.git", from: "1.0.1"),
    ],
    targets: [
        .target(
            name: "Favorite",
            dependencies: ["Core", "Common", "Components", "GameDetail"]
        ),
    ]
)
