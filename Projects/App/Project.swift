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
                    "CFBundleURLTypes": [
                        [
                            "CFBundleTypeRole": "Editor",
                            "CFBundleURLSchemes": ["com.googleusercontent.apps.201778913659-bvg35i2omhf2dbsdhdenia5pf3hrqvsh"],
                        ],
                    ],
                    "UILaunchStoryboardName": "LaunchScreen",
                    "UIApplicationSceneManifest": [
                        "UIApplicationSupportsMultipleScenes": false,
                        "UISceneConfigurations": [],
                    ],
                    "UIUserInterfaceStyle": "Light",
                    "UISupportedInterfaceOrientations": [
                        "UIInterfaceOrientationPortrait",
                    ],
                ]
            ),
            sources: [
                "Sources/**",
            ],
            resources: [
                .glob(pattern: "Resources/**", excluding: ["**/GoogleService-Info.plist.encrypted"]),
            ],
            entitlements: "Swirl.entitlements",
            dependencies: [
                .external(name: "ComposableArchitecture"),
                .external(name: "HyphenAuthenticate"),
                .external(name: "TCACoordinators"),
                .core,
                .shared,
                .feature,
            ]
        )
    ),
]

let project: Project = .makeModule(
    name: "swirl",
    targets: targets,
    resourceSynthesizers: [.assets()],
    settings: appCommonSettings
)
