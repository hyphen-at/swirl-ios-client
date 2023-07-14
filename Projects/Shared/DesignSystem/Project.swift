import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: ModulePath.Shared.name + ModulePath.Shared.DesignSystem.rawValue,
    targets: [
        .shared(
            implements: .DesignSystem,
            factory: .init(
                product: .framework,
                productName: "SwirlDesignSystem",
                resources: [
                    "Resources/**",
                ],
                dependencies: [
                    .external(name: "SnapKit-Dynamic"),
                ]
            )
        ),
    ],
    resourceSynthesizers: [.assets(), .strings()],
    settings: moduleCommonSettingsWithDesignSystemBridgingHeader
)
