// swift-tools-version: 5.11
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PhotonColorConversionKit",
    platforms: [
        .iOS(.v15),
        .macOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PhotonColorConversionKit",
            targets: ["PhotonColorConversionKit", "PhotonColorConversionKitC"]
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "PhotonColorConversionKit",
            dependencies: ["PhotonColorConversionKitC"]
        ),
        .target(
            name: "PhotonColorConversionKitC",
            cSettings: [
                // The client should set the MTL_HEADER_SEARCH_PATHS to $(HEADER_SEARCH_PATHS)
                // https://github.com/MetalPetal/MetalPetal/issues/223
                .headerSearchPath("include")
            ]
        ),
        .testTarget(
            name: "PhotonColorConversionKitTests",
            dependencies: ["PhotonColorConversionKit"]
        ),
    ]
)
