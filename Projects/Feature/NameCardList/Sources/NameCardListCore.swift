import ComposableArchitecture
import Dependencies
import SwiftUI
import SwirlBlockchain
import SwirlModel

public struct NameCardList: ReducerProtocol {
    public struct State: Equatable {
        public var isLoading: Bool = true
        public var profiles: [SwirlProfile] = []
        public var moments: [SwirlMoment] = []

        public var signatureData: String = ""
        public var nonce: Int = 0

        public var isTransactionProcessing: Bool = false

        public init() {}
    }

    public enum Action {
        case loading
        case loadingComplete(profiles: [SwirlProfile], moments: [SwirlMoment])

        case onProfileIconClick

        case startAutoRefresh

        case createSignaturePayload
        case createSignaturePayloadDone(String)

        case onNameCardClick(profile: SwirlProfile, momentId: UInt64)

        case startTransaction([SwirlMomentSignaturePayload])
        case transactionComplete
    }

    public struct ProofOfMeeting: Codable {
        let address: String
        let lat: Float
        let lng: Float
        let nonce: Int

        private enum CodingKeys: String, CodingKey {
            case address
            case lat
            case lng
            case nonce
        }
    }

    @Dependency(\.swirlBlockchainClient) var blockchainClient
    @Dependency(\.mainRunLoop) var mainRunLoop

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .loading:
                return .run { dispatch in
                    let moments = try await blockchainClient.getMomentList()
                    let myProfile = try await blockchainClient.getMyNameCard()!

                    await dispatch(.loadingComplete(profiles: [myProfile] + moments.map(\.profile), moments: moments))
                }
            case let .loadingComplete(profiles, moments):
                state.isLoading = false
                state.profiles = profiles
                state.moments = moments

                return .none
            case .startAutoRefresh:
                return .run { dispatch in
                    for await _ in mainRunLoop.timer(interval: .seconds(5)) {
                        await dispatch(.loading)
                    }
                }
            case .createSignaturePayload:
                return .run { dispatch in
                    let signatureData = try await blockchainClient.evalProfOfMeetingSignData(37.5313128, 127.0077684)
                    print(signatureData)
                    await dispatch(.createSignaturePayloadDone(signatureData))
                }
            case let .createSignaturePayloadDone(signaturePayload):
                state.signatureData = signaturePayload
                state.nonce = try! JSONDecoder().decode(ProofOfMeeting.self, from: signaturePayload.data(using: .utf8)!).nonce
                return .none
            case let .startTransaction(payload):
                state.isTransactionProcessing = true

                return .run { dispatch in
                    let sortedPayload = payload.sorted { $0.address < $1.address }

                    if sortedPayload.first?.address == blockchainClient.getCachedAccountAddress() {
                        try await blockchainClient.mintMoment(sortedPayload)
                        await dispatch(.transactionComplete)
                    } else {
                        try await Task.sleep(nanoseconds: 20_000_000_000)
                        await dispatch(.transactionComplete)
                    }
                }
            case .transactionComplete:
                state.isTransactionProcessing = false
                return .none
            default:
                return .none
            }
        }
    }

    public init() {}
}
