import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let targets: [Target] = [
    .feature(
        factory: .init(
            name: "SwirlFeature",
            product: .staticLibrary,
            dependencies: [
                .feature(implements: .SignIn),
            ]
        )
    ),
]

let project: Project = .makeModule(
    name: "Feature",
    targets: targets
)
