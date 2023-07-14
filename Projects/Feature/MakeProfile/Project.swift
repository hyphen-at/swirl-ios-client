import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: ModulePath.Feature.name + ModulePath.Feature.MakeProfile.rawValue,
    targets: [
        .feature(
            implements: .MakeProfile,
            factory: .init(
                productName: "SwirlMakeProfileFeature",
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
