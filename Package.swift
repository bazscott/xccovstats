// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "xccovstats",
    dependencies: [
        .package(url: "https://github.com/apple/swift-package-manager.git", from: "0.2.0")
    ],
    targets: [
        // Executable
        .target(name: "xccovstats", dependencies: ["Core"]),
        // Dependencies
        .target(name: "Core", dependencies: ["Utility"]),
        // Tests
        .testTarget(name: "CoreTests", dependencies: ["Core"])
    ]
)
