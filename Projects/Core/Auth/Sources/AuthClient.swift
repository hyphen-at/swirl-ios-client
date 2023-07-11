import Dependencies
import Foundation
import HyphenAuthenticate
import XCTestDynamicOverlay

public struct AuthClient: Sendable {
    public var signInWithGoogle: @Sendable () async throws -> Void
}

// - MARK: Implementation of AuthClient

extension AuthClient: DependencyKey {
    public static var liveValue = Self(
        signInWithGoogle: {
            try await HyphenAuthenticate.shared.authenticate(provider: .google)
        }
    )
}

// MARK: TestDependencyKey

extension AuthClient: TestDependencyKey {
    public static var testValue = Self(
        signInWithGoogle: unimplemented("\(Self.self).signInWithGoogle")
    )
}

// MARK: Add Dependency

public extension DependencyValues {
    var swirlAuthClient: AuthClient {
        get { self[AuthClient.self] }
        set { self[AuthClient.self] = newValue }
    }
}
