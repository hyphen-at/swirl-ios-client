import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: ModulePath.Feature.name + ModulePath.Feature.NameCardList.rawValue,
    targets: [
        .feature(
            implements: .NameCardList,
            factory: .init(
                productName: "SwirlNameCardListFeature",
                resources: [
                    "Resources/**",
                ],
                dependencies: [
                    .external(name: "SwiftUIIntrospect"),
                    .external(name: "ComposableArchitecture"),
                    .external(name: "Dependencies"),
                    // .framework(path: .relativeToRoot("PrebuiltFrameworks/NearbyCoreAdapter.framework")),
                    .framework(path: .relativeToRoot("PrebuiltFrameworks/NearbyConnections.framework")),
                    .shared(implements: .DesignSystem),
                    .shared(implements: .Model),
                ]
            )
        ),
    ],
    resourceSynthesizers: [.assets(), .strings()],
    settings: moduleCommonSettings
)
