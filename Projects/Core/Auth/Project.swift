import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: ModulePath.Core.name + ModulePath.Core.Auth.rawValue,
    targets: [
        .core(
            implements: .Auth,
            factory: .init(
                productName: "SwirlAuth",
                dependencies: [
                    .external(name: "Dependencies"),
                    .external(name: "XCTestDynamicOverlay"),
                    .external(name: "HyphenAuthenticate"),
                ]
            )
        ),
    ],
    resourceSynthesizers: [],
    settings: moduleCommonSettings
)
