// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PasscodeTextField",
    platforms: [ .iOS(.v11)],
    products: [
        .library(
            name: "PasscodeTextField",
            targets: ["PasscodeTextField"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "PasscodeTextField",
            dependencies: [],
            path: "Sources"),
        .testTarget(
            name: "PasscodeTextFieldTests",
            dependencies: ["PasscodeTextField"],
            path: "PasscodeTextFieldTests"),
    ]
)
