import Foundation
import ProjectDescription

public enum ModulePath {
    case feature(Feature)
    case core(Core)
    case shared(Shared)
}

// MARK: - App Module

public extension ModulePath {
    enum App: String, CaseIterable {
        case IOS

        public static let name: String = "App"
    }
}

// MARK: - Feature Module

public extension ModulePath {
    enum Feature: String, CaseIterable {
        case MakeProfile
        case NameCardList
        case SignIn

        public static let name: String = "Feature"
    }
}

// MARK: - Core Module

public extension ModulePath {
    enum Core: String, CaseIterable {
        case Auth

        public static let name: String = "Core"
    }
}

// MARK: - Shared Module

public extension ModulePath {
    enum Shared: String, CaseIterable {
        case DesignSystem

        public static let name: String = "Shared"
    }
}
