import Dependencies
import Foundation
import SwirlModel
import XCTestDynamicOverlay

public struct BlockchainClient: Sendable {
    public var fetchFlowAccount: @Sendable () async throws -> Void
    public var getMyNameCard: @Sendable () async throws -> SwirlProfile?
}

// - MARK: Implementation of BlockchainClient

extension BlockchainClient: DependencyKey {
    public static var liveValue = Self(
        fetchFlowAccount: {
            try await SwirlBlockchainManager.shared.loadAccount()
        },
        getMyNameCard: {
            try await SwirlBlockchainManager.shared.getMyNameCard()
        }
    )
}

// MARK: TestDependencyKey

extension BlockchainClient: TestDependencyKey {
    public static var testValue = Self(
        fetchFlowAccount: unimplemented("\(Self.self).fetchFlowAccount"),
        getMyNameCard: unimplemented("\(Self.self).getMyNameCard")
    )
}

// MARK: Add Dependency

public extension DependencyValues {
    var swirlBlockchainClient: BlockchainClient {
        get { self[BlockchainClient.self] }
        set { self[BlockchainClient.self] = newValue }
    }
}
