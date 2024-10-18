// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EzklPackage",
    platforms: [
         .iOS("17.5.0")
     ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "EzklPackage",
            targets: ["EzklPackage"]),
    ],
    dependencies: [
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "EzklPackage",
            dependencies: [
                .byName(name: "EzklCore")
            ],
            path: "Sources/"
        ),
        .binaryTarget(
            name: "EzklCore",
            path: "Sources/EzklCoreBindings/EzklCore.xcframework"
        ),
        .testTarget(
            name: "EzklPackageTests",
            dependencies: ["EzklPackage"],
            path: "Tests/",
            resources: [
                .process("EzklAssets/input.json"),
                .process("EzklAssets/kzg.srs"),
                .process("EzklAssets/network.ezkl"),
                .process("EzklAssets/settings.json"),
            ]
        )
    ]
)
