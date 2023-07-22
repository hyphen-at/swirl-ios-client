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
                    "UIAppFonts": [
                        "PPObjectSans-Bold.otf",
                        "PPObjectSans-Medium.otf",
                    ],
                    "NSBluetoothAlwaysUsageDescription": "Use to share the SWIRL Name Card.",
                    "NSLocalNetworkUsageDescription": "Use this permission to locate the neighboring SWIRL user.",
                    "NSNearbyInteractionAllowOnceUsageDescription": "Use to share the SWIRL Name Card.",
                    "NSNearbyInteractionUsageDescription": "Use to share the SWIRL Name Card.",
                    "NSFaceIDUsageDescription": "Signing transaction with device key.",
                    "NSBonjourServices": [
                        "_248FAD1DE957._tcp",
                        "_swirl._tcp",
                    ],
                    "UIBackgroundModes": ["remote-notification"],
                ]
            ),
            sources: [
                "Sources/**",
            ],
            resources: [
                .glob(
                    pattern: "Resources/**",
                    excluding: [
                        "**/GoogleService-Info.plist.encrypted",
                        "**/PPObjectSans-Bold.otf.encrypted",
                        "**/PPObjectSans-Medium.otf.encrypted",
                    ]
                ),
            ],
            entitlements: "Swirl.entitlements",
            dependencies: [
                .external(name: "ComposableArchitecture"),
                .external(name: "HyphenAuthenticate"),
                .external(name: "TCACoordinators"),
                .external(name: "HyphenUI"),
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
