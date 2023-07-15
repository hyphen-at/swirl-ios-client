import ProjectDescription

let SPM = SwiftPackageManagerDependencies([
    .remote(url: "https://github.com/pointfreeco/swift-composable-architecture", requirement: .upToNextMajor(from: "0.55.0")),
    .remote(url: "https://github.com/johnpatrickmorgan/TCACoordinators", requirement: .upToNextMajor(from: "0.4.0")),
    .remote(url: "https://github.com/davdroman/swiftui-navigation-transitions", requirement: .upToNextMajor(from: "0.10.1")),
    .package(url: "https://github.com/siteline/swiftui-introspect", from: "0.9.1"),
    .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1")),
    .package(url: "https://github.com/davdroman/swiftui-navigation-transitions", .upToNextMajor(from: "0.10.1")),
    .package(url: "https://github.com/gonzalezreal/NetworkImage", from: "5.0.0"),
    .local(path: .relativeToRoot("hyphen-ios-sdk")),
])

let dependencies = Dependencies(
    swiftPackageManager: SPM,
    platforms: [.iOS, .watchOS]
)
