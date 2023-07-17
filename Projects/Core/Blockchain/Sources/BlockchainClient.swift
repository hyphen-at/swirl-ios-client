import Dependencies
import Foundation
import SwirlModel
import XCTestDynamicOverlay

public struct BlockchainClient: Sendable {
    public var fetchFlowAccount: @Sendable () async throws -> Void
    public var getMyNameCard: @Sendable () async throws -> SwirlProfile?
    public var getNameCardList: @Sendable () async throws -> [SwirlProfile]

    public var createMyNameCard: @Sendable (CreateMyNameCardPayload) async throws -> Void

    public var evalProfOfMeetingSignData: @Sendable (Float, Float) async throws -> String

    public struct CreateMyNameCardPayload {
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

// - MARK: Implementation of BlockchainClient

extension BlockchainClient: DependencyKey {
    public static var liveValue = Self(
        fetchFlowAccount: {
            try await SwirlBlockchainManager.shared.loadAccount()
        },
        getMyNameCard: {
            try await SwirlBlockchainManager.shared.getMyNameCard()
        },
        getNameCardList: {
            try await SwirlBlockchainManager.shared.getNameCardList()
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
        }
    )
}

// MARK: TestDependencyKey

extension BlockchainClient: TestDependencyKey {
    public static var testValue = Self(
        fetchFlowAccount: unimplemented("\(Self.self).fetchFlowAccount"),
        getMyNameCard: unimplemented("\(Self.self).getMyNameCard"),
        getNameCardList: unimplemented("\(Self.self).getNameCardList"),
        createMyNameCard: unimplemented("\(Self.self).createMyNameCard"),
        evalProfOfMeetingSignData: unimplemented("\(Self.self).evalProfOfMeetingSignData")
    )
}

// MARK: Add Dependency

public extension DependencyValues {
    var swirlBlockchainClient: BlockchainClient {
        get { self[BlockchainClient.self] }
        set { self[BlockchainClient.self] = newValue }
    }
}
