import DependencyPlugin
import ProjectDescription

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
