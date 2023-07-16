import Dependencies
import Foundation
import HyphenAuthenticate
import HyphenCore
import XCTestDynamicOverlay

public struct AuthClient: Sendable {
    public var isHyphenLoggedIn: @Sendable () -> Bool
    public var signInWithGoogle: @Sendable () async throws -> Void
}

// - MARK: Implementation of AuthClient

extension AuthClient: DependencyKey {
    public static var liveValue = Self(
        isHyphenLoggedIn: {
            Hyphen.shared.isCredentialExist()
        },
        signInWithGoogle: {
            try await HyphenAuthenticate.shared.authenticate(provider: .google)
        }
    )
}

// MARK: TestDependencyKey

extension AuthClient: TestDependencyKey {
    public static var testValue = Self(
        isHyphenLoggedIn: unimplemented("\(Self.self).isHyphenLoggedIn"),
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
