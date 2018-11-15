// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.
// - SR-631: requires swift 4.2-dev toolchain to build.
// % export TOOLCHAINS=swift`

import PackageDescription

let package = Package(
    name: "SwiftDraw",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "SwiftDraw",
            targets: ["SwiftDraw"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SwiftDraw",
            dependencies: [],
			path: "SwiftDraw",
			exclude: ["UIImage+Image.swift", "NSImage+Image.swift"]),
        .testTarget(
            name: "SwiftDrawTests",
            dependencies: ["SwiftDraw"],
            path: "SwiftDrawTests",
			exclude: ["Parser.ImageTests.swift", "CGRenderer.PathTests.swift"])
    ]
)