import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: ModulePath.Feature.name + ModulePath.Feature.NameCardDetail.rawValue,
    targets: [
        .feature(
            implements: .NameCardDetail,
            factory: .init(
                productName: "SwirlNameCardDetailFeature",
                resources: [
                    "Resources/**",
                ],
                dependencies: [
                    .external(name: "SwiftUIIntrospect"),
                    .external(name: "ComposableArchitecture"),
                    .external(name: "Dependencies"),
                    .external(name: "NetworkImage"),
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
