import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let targets: [Target] = [
    .shared(
        factory: .init(
            name: "SwirlShared",
            product: .staticLibrary,
            dependencies: [
                .shared(implements: .DesignSystem),
                .shared(implements: .Model),
            ]
        )
    ),
]

let project: Project = .makeModule(
    name: "Shared",
    targets: targets
)
