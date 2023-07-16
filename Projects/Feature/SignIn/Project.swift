import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: ModulePath.Feature.name + ModulePath.Feature.SignIn.rawValue,
    targets: [
        .feature(
            implements: .SignIn,
            factory: .init(
                productName: "SwirlSignInFeature",
                resources: [
                    "Resources/**",
                ],
                dependencies: [
                    .external(name: "SwiftUIIntrospect"),
                    .external(name: "ComposableArchitecture"),
                    .external(name: "Dependencies"),
                    .core(implements: .Auth),
                    .core(implements: .Blockchain),
                    .shared(implements: .DesignSystem),
                ]
            )
        ),
    ],
    resourceSynthesizers: [.assets(), .strings()],
    settings: moduleCommonSettings
)
