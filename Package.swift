// swift-tools-version:5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DynuREST",
    platforms: [
        .macOS(.v13),
        .macCatalyst(.v16),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9),
        .visionOS(.v1),
    ],
    products: [
        .library(name: "DynuREST", targets: ["DynuREST"]),
        .executable(name: "dynu", targets: ["cli"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-testing.git", from: "6.2.0"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.7.0"),
        .package(url: "https://github.com/richardpiazza/SessionPlus.git", from: "3.0.0-beta.2"),
        .package(url: "https://github.com/johnsundell/ShellOut.git", from: "2.3.0"),
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
                .product(
                    name: "ShellOut",
                    package: "ShellOut",
                    condition: .when(
                        platforms: [
                            .macOS,
                            .linux,
                        ]
                    )
                ),
            ]
        ),
        .testTarget(
            name: "DynuRESTTests",
            dependencies: [
                "DynuREST",
                .product(name: "Testing", package: "swift-testing"),
            ]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
