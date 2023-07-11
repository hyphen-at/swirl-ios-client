import ProjectDescription
import ProjectDescriptionHelpers

let targets: [Target] = [
    .app(
        implements: .IOS,
        factory: .init(
            infoPlist: .extendingDefault(
                with: [
                    "CFBundleShortVersionString": "1.0",
                    "CFBundleVersion": "1",
                    "UILaunchStoryboardName": "LaunchScreen",
                    "UIApplicationSceneManifest": [
                        "UIApplicationSupportsMultipleScenes": false,
                        "UISceneConfigurations": [],
                    ],
                    "UIUserInterfaceStyle": "Dark",
                    "UISupportedInterfaceOrientations": [
                        "UIInterfaceOrientationPortrait",
                    ],
                ]
            ),
            sources: [
                "Sources/**",
            ],
            resources: [
                "Resources/**",
            ],
            dependencies: []
        )
    ),
]

let project: Project = .makeModule(
    name: "swirl",
    targets: targets,
    resourceSynthesizers: [.assets()]
)
