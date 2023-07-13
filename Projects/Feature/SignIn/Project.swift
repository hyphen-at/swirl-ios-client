import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: ModulePath.Feature.name + ModulePath.Feature.SignIn.rawValue,
    targets: [
        .feature(
            implements: .SignIn,
            factory: .init(
                product: .framework,
                productName: "SwirlSignInFeature",
                resources: [
                    "Resources/**",
                ],
                dependencies: [
                    .external(name: "ComposableArchitecture"),
                    .external(name: "Dependencies"),
                ]
            )
        ),
    ],
    resourceSynthesizers: [.assets(), .strings()],
    settings: moduleCommonSettings
)
