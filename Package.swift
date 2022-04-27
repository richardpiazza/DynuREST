// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DynuREST",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    products: [
        .library(name: "DynuREST", targets: ["DynuREST"]),
        .executable(name: "dynu", targets: ["cli"]),
    ],
    dependencies: [
        .package(url: "https://github.com/richardpiazza/SessionPlus.git", .upToNextMajor(from: "2.0.1")),
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.1.1")),
    ],
    targets: [
        .executableTarget(
            name: "cli",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "DynuREST",
            ]
        ),
        .target(
            name: "DynuREST",
            dependencies: ["SessionPlus"]
        ),
        .testTarget(
            name: "DynuRESTTests",
            dependencies: ["DynuREST"]
        )
    ],
    swiftLanguageVersions: [.v5]
)
