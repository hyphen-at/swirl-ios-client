import Foundation
import ProjectDescription

public extension Project {
    enum Environment {
        public static let appName = "Swirl"
        public static let deploymentTarget = DeploymentTarget.iOS(targetVersion: "15.0", devices: [.iphone])
        public static let bundlePrefix = "at.hyphen.Swirl"
    }
}
