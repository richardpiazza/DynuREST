// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DynuREST",
    platforms: [
        .macOS(.v12),
        .iOS(.v15),
        .tvOS(.v15),
        .watchOS(.v8),
    ],
    products: [
        .library(name: "DynuREST", targets: ["DynuREST"]),
        .executable(name: "dynu", targets: ["cli"]),
    ],
    dependencies: [
        .package(url: "https://github.com/richardpiazza/SessionPlus.git", .upToNextMajor(from: "2.2.0")),
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.2.2")),
        .package(url: "https://github.com/johnsundell/ShellOut.git", from: "2.3.0")
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
            dependencies: [
                "SessionPlus",
                "ShellOut"
            ]
        ),
        .testTarget(
            name: "DynuRESTTests",
            dependencies: ["DynuREST"]
        )
    ],
    swiftLanguageVersions: [.v5]
)
