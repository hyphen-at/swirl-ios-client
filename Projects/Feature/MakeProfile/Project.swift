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
                    .external(name: "NavigationTransitions"),
                    // .external(name: "FCL_SDK"),
                    .shared(implements: .DesignSystem),
                    .core(implements: .Blockchain),
                ]
            )
        ),
    ],
    resourceSynthesizers: [.assets(), .strings()],
    settings: moduleCommonSettings
)
