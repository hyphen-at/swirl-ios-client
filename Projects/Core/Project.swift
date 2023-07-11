import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let targets: [Target] = [
    .core(
        factory: .init(
            name: "SwirlCore",
            product: .staticLibrary,
            dependencies: [
                .core(implements: .Auth),
            ]
        )
    ),
]

let project: Project = .makeModule(
    name: "Core",
    targets: targets
)
