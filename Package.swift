// swift-tools-version:5.5
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
        .library(name: "DynuREST", targets: ["DynuREST"])
    ],
    dependencies: [
        .package(url: "https://github.com/richardpiazza/SessionPlus.git", .upToNextMajor(from: "2.0.0"))
    ],
    targets: [
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
