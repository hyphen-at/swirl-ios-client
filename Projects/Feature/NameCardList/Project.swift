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
                    .shared(implements: .DesignSystem),
                ]
            )
        ),
    ],
    resourceSynthesizers: [.assets(), .strings()],
    settings: moduleCommonSettings
)
