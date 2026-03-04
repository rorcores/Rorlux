// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Rorlux",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(
            name: "Rorlux",
            path: "Sources/Rorlux"
        )
    ]
)
