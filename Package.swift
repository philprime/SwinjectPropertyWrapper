// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SwinjectPropertyWrapper",
    products: [
        .library(name: "SwinjectPropertyWrapper", targets: ["SwinjectPropertyWrapper"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Swinject/Swinject", .upToNextMajor(from: "2.7.1")),
        .package(url: "https://github.com/Quick/Quick", .upToNextMajor(from: "3.0.0")),
        .package(url: "https://github.com/Quick/Nimble", .upToNextMajor(from: "9.0.0")),
    ],
    targets: [
        .target(name: "SwinjectPropertyWrapper", dependencies: ["Swinject"]),
        .testTarget(name: "SwinjectPropertyWrapperTests", dependencies: [
            "SwinjectPropertyWrapper",
            "Quick",
            "Nimble"
        ]),
    ]
)
