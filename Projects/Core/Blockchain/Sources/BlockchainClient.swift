import Dependencies
import Foundation
import SwirlModel
import XCTestDynamicOverlay

public struct BlockchainClient: Sendable {
    public var fetchFlowAccount: @Sendable () async throws -> Void
    public var getCachedAccountAddress: @Sendable () -> String
    public var getMyNameCard: @Sendable () async throws -> SwirlProfile?
    public var getNameCardList: @Sendable () async throws -> [SwirlProfile]
    public var getMomentList: @Sendable () async throws -> [SwirlMoment]

    public var createMyNameCard: @Sendable (CreateMyNameCardPayload) async throws -> Void

    public var evalProfOfMeetingSignData: @Sendable (Float, Float) async throws -> String
    public var mintMoment: @Sendable ([SwirlMomentSignaturePayload]) async throws -> Void
    public var burnMoment: @Sendable () async throws -> Void
}

// - MARK: Implementation of BlockchainClient

extension BlockchainClient: DependencyKey {
    public static var liveValue = Self(
        fetchFlowAccount: {
            try await SwirlBlockchainManager.shared.loadAccount()
        },
        getCachedAccountAddress: {
            SwirlBlockchainManager.shared.getCachedAccountAddress()
        },
        getMyNameCard: {
            try await SwirlBlockchainManager.shared.getMyNameCard()
        },
        getNameCardList: {
            try await SwirlBlockchainManager.shared.getNameCardList()
        },
        getMomentList: {
            try await SwirlBlockchainManager.shared.getMomentList()
        },
        createMyNameCard: { payload in
            try await SwirlBlockchainManager.shared.createMyNameCard(
                nickname: payload.nickname,
                profileImage: payload.profileImage,
                keywords: payload.keywords,
                color: payload.color,
                twitterHandle: payload.twitterHandle,
                telegramHandle: payload.telegramHandle,
                discordHandle: payload.discordHandle,
                threadHandle: payload.threadHandle
            )
        },
        evalProfOfMeetingSignData: { lat, lng in
            try await SwirlBlockchainManager.shared.evalProfOfMeetingSignData(lat: lat, lng: lng)
        },
        mintMoment: { payload in
            try await SwirlBlockchainManager.shared.mintMoment(payload: payload)
        },
        burnMoment: {
            try await SwirlBlockchainManager.shared.burnAllMoment()
        }
    )
}

// MARK: TestDependencyKey

extension BlockchainClient: TestDependencyKey {
    public static var testValue = Self(
        fetchFlowAccount: unimplemented("\(Self.self).fetchFlowAccount"),
        getCachedAccountAddress: unimplemented("\(Self.self).getCachedAccountAddress"),
        getMyNameCard: unimplemented("\(Self.self).getMyNameCard"),
        getNameCardList: unimplemented("\(Self.self).getNameCardList"),
        getMomentList: unimplemented("\(Self.self).getMomentList"),
        createMyNameCard: unimplemented("\(Self.self).createMyNameCard"),
        evalProfOfMeetingSignData: unimplemented("\(Self.self).evalProfOfMeetingSignData"),
        mintMoment: unimplemented("\(Self.self).mintMoment"),
        burnMoment: unimplemented("\(Self.self).burnMoment")
    )
}

// MARK: Add Dependency

public extension DependencyValues {
    var swirlBlockchainClient: BlockchainClient {
        get { self[BlockchainClient.self] }
        set { self[BlockchainClient.self] = newValue }
    }
}

// MARK: - CreateMyNameCardPayload

public extension BlockchainClient {
    struct CreateMyNameCardPayload {
        public let nickname: String
        public let profileImage: String
        public let keywords: [String]
        public let color: String
        public let twitterHandle: String?
        public let telegramHandle: String?
        public let discordHandle: String?
        public let threadHandle: String?

        public init(nickname: String, profileImage: String, keywords: [String], color: String, twitterHandle: String?, telegramHandle: String?, discordHandle: String?, threadHandle: String?) {
            self.nickname = nickname
            self.profileImage = profileImage
            self.keywords = keywords
            self.color = color
            self.twitterHandle = twitterHandle
            self.telegramHandle = telegramHandle
            self.discordHandle = discordHandle
            self.threadHandle = threadHandle
        }
    }
}
