import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: ModulePath.Shared.name + ModulePath.Shared.Model.rawValue,
    targets: [
        .shared(
            implements: .Model,
            factory: .init(
                product: .framework,
                productName: "SwirlModel",
                dependencies: []
            )
        ),
    ],
    resourceSynthesizers: [],
    settings: moduleCommonSettings
)
