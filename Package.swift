// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "DynuREST",
    products: [
        .library(name: "DynuREST", targets: ["DynuREST"])
    ],
    dependencies: [
        .package(url: "https://github.com/richardpiazza/CodeQuickKit.git", from: "6.0.0")
    ],
    targets: [
        .target(name: "DynuREST", dependencies: ["CodeQuickKit"], path: "Sources"),
        .testTarget(name: "DynuRESTTests", dependencies: ["DynuREST"], path: "Tests")
    ]
)
