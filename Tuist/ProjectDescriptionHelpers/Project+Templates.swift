import DependencyPlugin
import ProjectDescription

public let appCommonSettings: Settings = .settings(
    base: [
        "OTHER_LDFLAGS": "-ObjC",
        "OTHER_SWIFT_FLAGS": "$(inherited) -Xcc -Wno-error=non-modular-include-in-framework-module",
        "HEADER_SEARCH_PATHS": [
            "$(inherited)",
            "$(SRCROOT)/../../Tuist/Dependencies/SwiftPackageManager/.build/checkouts/GoogleSignIn-iOS/GoogleSignIn/Sources/Public",
            "$(SRCROOT)/../../Tuist/Dependencies/SwiftPackageManager/.build/checkouts/AppAuth-iOS/Source/AppAuth",
            "$(SRCROOT)/../../Tuist/Dependencies/SwiftPackageManager/.build/checkouts/AppAuth-iOS/Source/AppAuthCore",
            "$(SRCROOT)/../../Tuist/Dependencies/SwiftPackageManager/.build/checkouts/gtm-session-fetcher/Sources/Core/Public",
            "$(SRCROOT)/../../Tuist/Dependencies/SwiftPackageManager/.build/checkouts/GTMAppAuth/GTMAppAuth/Sources/Public/GTMAppAuth"],
    ]
)

public let moduleCommonSettings: Settings = .settings(
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

public extension Project {
    static func makeModule(name: String, targets: [Target]) -> Self {
        let name: String = name
        let organizationName: String? = nil
        let options: Project.Options = .options()
        let packages: [Package] = []
        let settings: Settings? = nil
        let targets: [Target] = targets
        let schemes: [Scheme] = []
        let fileHeaderTemplate: FileHeaderTemplate? = nil
        let additionalFiles: [FileElement] = []
        let resourceSynthesizers: [ResourceSynthesizer] = []

        return .init(
            name: name,
            organizationName: organizationName,
            options: options,
            packages: packages,
            settings: settings,
            targets: targets,
            schemes: schemes,
            fileHeaderTemplate: fileHeaderTemplate,
            additionalFiles: additionalFiles,
            resourceSynthesizers: resourceSynthesizers
        )
    }

    static func makeModule(name: String, targets: [Target], resourceSynthesizers: [ResourceSynthesizer]) -> Self {
        let name: String = name
        let organizationName: String? = nil
        let options: Project.Options = .options()
        let packages: [Package] = []
        let settings: Settings? = nil
        let targets: [Target] = targets
        let schemes: [Scheme] = []
        let fileHeaderTemplate: FileHeaderTemplate? = nil
        let additionalFiles: [FileElement] = []
        let resourceSynthesizers: [ResourceSynthesizer] = resourceSynthesizers

        return .init(
            name: name,
            organizationName: organizationName,
            options: options,
            packages: packages,
            settings: settings,
            targets: targets,
            schemes: schemes,
            fileHeaderTemplate: fileHeaderTemplate,
            additionalFiles: additionalFiles,
            resourceSynthesizers: resourceSynthesizers
        )
    }

    static func makeModule(name: String, targets: [Target], resourceSynthesizers: [ResourceSynthesizer], settings: Settings) -> Self {
        let name: String = name
        let organizationName: String? = nil
        let options: Project.Options = .options()
        let packages: [Package] = []
        let settings: Settings = settings
        let targets: [Target] = targets
        let schemes: [Scheme] = []
        let fileHeaderTemplate: FileHeaderTemplate? = nil
        let additionalFiles: [FileElement] = []
        let resourceSynthesizers: [ResourceSynthesizer] = resourceSynthesizers

        return .init(
            name: name,
            organizationName: organizationName,
            options: options,
            packages: packages,
            settings: settings,
            targets: targets,
            schemes: schemes,
            fileHeaderTemplate: fileHeaderTemplate,
            additionalFiles: additionalFiles,
            resourceSynthesizers: resourceSynthesizers
        )
    }
}
