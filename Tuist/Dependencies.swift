import ProjectDescription

let SPM = SwiftPackageManagerDependencies([
    .remote(url: "https://github.com/pointfreeco/swift-composable-architecture", requirement: .upToNextMajor(from: "0.55.0")),
    .remote(url: "https://github.com/johnpatrickmorgan/TCACoordinators", requirement: .upToNextMajor(from: "0.4.0")),
    .remote(url: "https://github.com/davdroman/swiftui-navigation-transitions", requirement: .upToNextMajor(from: "0.10.1")),
])

let dependencies = Dependencies(
    swiftPackageManager: SPM,
    platforms: [.iOS, .watchOS]
)
