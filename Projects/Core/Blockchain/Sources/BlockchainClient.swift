import Dependencies
import Foundation
import XCTestDynamicOverlay

public struct BlockchainClient: Sendable {
    public var fetchFlowAccount: @Sendable () async throws -> Void
}

// - MARK: Implementation of BlockchainClient

extension BlockchainClient: DependencyKey {
    public static var liveValue = Self(
        fetchFlowAccount: {
            try await SwirlBlockchainManager.shared.loadAccount()
        }
    )
}

// MARK: TestDependencyKey

extension BlockchainClient: TestDependencyKey {
    public static var testValue = Self(
        fetchFlowAccount: unimplemented("\(Self.self).fetchFlowAccount")
    )
}

// MARK: Add Dependency

public extension DependencyValues {
    var swirlBlockchainClient: BlockchainClient {
        get { self[BlockchainClient.self] }
        set { self[BlockchainClient.self] = newValue }
    }
}
