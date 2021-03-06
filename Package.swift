// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DynuREST",
    platforms: [
        .macOS(.v10_14),
        .iOS(.v12),
        .tvOS(.v12),
        .watchOS(.v5),
    ],
    products: [
        .library(name: "DynuREST", targets: ["DynuREST"])
    ],
    dependencies: [
        .package(url: "https://github.com/richardpiazza/SessionPlus.git", .upToNextMinor(from: "1.0.0"))
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
