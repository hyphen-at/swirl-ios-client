import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: ModulePath.Core.name + ModulePath.Core.Blockchain.rawValue,
    targets: [
        .core(
            implements: .Blockchain,
            factory: .init(
                productName: "SwirlBlockchain",
                dependencies: [
                    .external(name: "Dependencies"),
                    .external(name: "XCTestDynamicOverlay"),
                    .external(name: "HyphenAuthenticate"),
                    .external(name: "Flow"),
                ]
            )
        ),
    ],
    resourceSynthesizers: [],
    settings: moduleCommonSettings
)
