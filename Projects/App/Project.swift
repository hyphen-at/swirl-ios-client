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
                .glob(pattern: "Resources/**", excluding: ["**/GoogleService-Info.plist.encrypted"]),
            ],
            dependencies: [
                .external(name: "ComposableArchitecture"),
                .external(name: "HyphenAuthenticate"),
                .external(name: "TCACoordinators"),
            ]
        )
    ),
]

let project: Project = .makeModule(
    name: "swirl",
    targets: targets,
    resourceSynthesizers: [.assets()],
    settings: .settings(
        base: [
            "OTHER_LDFLAGS": "-ObjC",
            "HEADER_SEARCH_PATHS": [
                "$(inherited)",
                "$(SRCROOT)/../../Tuist/Dependencies/SwiftPackageManager/.build/checkouts/GoogleSignIn-iOS/GoogleSignIn/Sources/Public",
                "$(SRCROOT)/../../Tuist/Dependencies/SwiftPackageManager/.build/checkouts/AppAuth-iOS/Source/AppAuth",
                "$(SRCROOT)/../../Tuist/Dependencies/SwiftPackageManager/.build/checkouts/AppAuth-iOS/Source/AppAuthCore",
                "$(SRCROOT)/../../Tuist/Dependencies/SwiftPackageManager/.build/checkouts/gtm-session-fetcher/Sources/Core/Public",
                "$(SRCROOT)/../../Tuist/Dependencies/SwiftPackageManager/.build/checkouts/GTMAppAuth/GTMAppAuth/Sources/Public/GTMAppAuth"],
        ]
    )
)
