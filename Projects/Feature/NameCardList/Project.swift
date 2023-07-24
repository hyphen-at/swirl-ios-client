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
                    .external(name: "LookingGlassUI"),
                    .external(name: "PartialSheet"),
                    .external(name: "NearbyCoreAdapter"),
                    .external(name: "NearbyConnections"),
                    .shared(implements: .DesignSystem),
                    .shared(implements: .Model),
                    .core(implements: .Blockchain),
                ]
            )
        ),
    ],
    resourceSynthesizers: [.assets(), .strings()],
    settings: moduleCommonSettings
)
