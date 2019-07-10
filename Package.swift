// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "URLFileManager",
    products: [
        .library(
            name: "URLFileManager",
            targets: ["URLFileManager"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "URLFileManager",
            dependencies: []),
        .testTarget(
            name: "URLFileManagerTests",
            dependencies: ["URLFileManager"]),
    ]
)
