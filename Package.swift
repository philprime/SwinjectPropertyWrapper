// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SwinjectPropertyWrapper",
    products: [
        .library(name: "SwinjectPropertyWrapper", targets: ["SwinjectPropertyWrapper"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Swinject/Swinject", .upToNextMajor(from: "2.7.1")),
        .package(url: "https://github.com/mattgallagher/CwlPreconditionTesting.git", .upToNextMajor(from: "2.2.2"))
    ],
    targets: [
        .target(name: "SwinjectPropertyWrapper", dependencies: ["Swinject"]),
        .testTarget(name: "SwinjectPropertyWrapperTests", dependencies: [
            "SwinjectPropertyWrapper",
            .product(name: "CwlPreconditionTesting", package: "CwlPreconditionTesting"),
            .product(name: "CwlPosixPreconditionTesting", package: "CwlpreconditionTesting")
        ]),
    ]
)
