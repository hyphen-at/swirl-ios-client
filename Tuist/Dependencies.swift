import ProjectDescription

let SPM = SwiftPackageManagerDependencies([
    .remote(url: "https://github.com/pointfreeco/swift-composable-architecture", requirement: .upToNextMajor(from: "0.55.0")),
    .remote(url: "https://github.com/johnpatrickmorgan/TCACoordinators", requirement: .upToNextMajor(from: "0.4.0")),
    .remote(url: "https://github.com/davdroman/swiftui-navigation-transitions", requirement: .upToNextMajor(from: "0.10.1")),
    .package(url: "https://github.com/siteline/swiftui-introspect", from: "0.9.1"),
    .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1")),
    .package(url: "https://github.com/gonzalezreal/NetworkImage", from: "5.0.0"),
    .package(url: "https://github.com/outblock/flow-swift.git", from: "0.3.3"),
    .package(url: "https://github.com/ryanlintott/LookingGlassUI", from: "0.3.1"),
    .package(url: "https://github.com/AndreaMiotto/PartialSheet", from: "3.1.0"),
    // .package(url: "https://github.com/portto/fcl-swift.git", from: "0.4.1"),
    .package(url: "https://github.com/hyphen-at/hyphen-ios-sdk.git", .branch("main")),
    .package(url: "https://github.com/dsa28s/nearby-connections-dynamic-xcframework.git", .branch("main")),
])

let dependencies = Dependencies(
    swiftPackageManager: SPM,
    platforms: [.iOS, .watchOS]
)
