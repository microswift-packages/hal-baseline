// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "HAL",
    products: [
        .library(
            name: "HAL",
            targets: ["HAL"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "HAL",
            dependencies: [],
            path: ".",
            sources: ["main.swift"]),
    ]
)
