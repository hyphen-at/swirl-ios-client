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
                ]
            )
        ),
    ],
    resourceSynthesizers: [],
    settings: .settings(
        base: [
            "OTHER_LDFLAGS": "-ObjC",
            "OTHER_SWIFT_FLAGS": "$(inherited) -Xcc -Wno-error=non-modular-include-in-framework-module",
            "HEADER_SEARCH_PATHS": [
                "$(inherited)",
                "$(SRCROOT)/../../../Tuist/Dependencies/SwiftPackageManager/.build/checkouts/GoogleSignIn-iOS/GoogleSignIn/Sources/Public",
                "$(SRCROOT)/../../../Tuist/Dependencies/SwiftPackageManager/.build/checkouts/AppAuth-iOS/Source/AppAuth",
                "$(SRCROOT)/../../../Tuist/Dependencies/SwiftPackageManager/.build/checkouts/AppAuth-iOS/Source/AppAuthCore",
                "$(SRCROOT)/../../../Tuist/Dependencies/SwiftPackageManager/.build/checkouts/gtm-session-fetcher/Sources/Core/Public",
                "$(SRCROOT)/../../../Tuist/Dependencies/SwiftPackageManager/.build/checkouts/GTMAppAuth/GTMAppAuth/Sources/Public/GTMAppAuth"],
        ]
    )
)
