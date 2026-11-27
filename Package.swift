// swift-tools-version: 6.4
import PackageDescription

let package = Package(
    name: "swift-w3c-wgsl",
    platforms: [.macOS(.v27), .iOS(.v27), .tvOS(.v27), .watchOS(.v27), .visionOS(.v27)],
    products: [.library(name: "W3C WGSL", targets: ["W3C WGSL"])],
    dependencies: [
        .package(url: "https://github.com/swift-w3c/swift-w3c.git", branch: "main")
    ],
    targets: [
        .target(
            name: "W3C WGSL",
            dependencies: [
                .product(name: "W3C", package: "swift-w3c")
            ]
        ),
        .testTarget(
            name: "W3C WGSL Tests",
            dependencies: [
                .target(name: "W3C WGSL")
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    target.swiftSettings =
        (target.swiftSettings ?? []) + [
            .strictMemorySafety(),
            .enableUpcomingFeature("ExistentialAny"),
            .enableUpcomingFeature("InternalImportsByDefault"),
            .enableUpcomingFeature("MemberImportVisibility"),
            .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
            .enableUpcomingFeature("InferIsolatedConformances"),
            .enableExperimentalFeature("Lifetimes"),
            .treatAllWarnings(as: .error),
        ]
}
