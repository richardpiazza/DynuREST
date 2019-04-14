// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "DynuREST",
    products: [
        .library(name: "DynuREST", targets: ["DynuREST"])
    ],
    dependencies: [
        .package(url: "https://github.com/richardpiazza/CodeQuickKit.git", .upToNextMinor(from: "6.5.0"))
    ],
    targets: [
        .target(name: "DynuREST", dependencies: ["CodeQuickKit"], path: "Sources"),
        .testTarget(name: "DynuRESTTests", dependencies: ["DynuREST"], path: "Tests")
    ],
    swiftLanguageVersions: [.v4_2, .v5]
)
