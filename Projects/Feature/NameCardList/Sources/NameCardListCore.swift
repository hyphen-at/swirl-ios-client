import ComposableArchitecture
import Dependencies
import SwiftUI
import SwirlBlockchain
import SwirlModel

public struct NameCardList: ReducerProtocol {
    public struct State: Equatable {
        public var isLoading: Bool = true
        public var profiles: [SwirlProfile] = []

        public var signatureData: String = ""

        public init() {}
    }

    public enum Action {
        case loading
        case loadingComplete(profiles: [SwirlProfile])

        case createSignaturePayload
        case createSignaturePayloadDone(String)

        case onNameCardClick(profile: SwirlProfile)
    }

    @Dependency(\.swirlBlockchainClient) var blockchainClient

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .loading:
                return .run { dispatch in
                    let profiles = try await blockchainClient.getNameCardList()
                    let myProfile = try await blockchainClient.getMyNameCard()!

                    await dispatch(.loadingComplete(profiles: [myProfile] + profiles))
                }
            case let .loadingComplete(profiles):
                state.isLoading = false
                state.profiles = profiles

                return .none
            case .createSignaturePayload:
                return .run { dispatch in
                    let signatureData = try await blockchainClient.evalProfOfMeetingSignData(37.5313128, 127.0077684)

                    await dispatch(.createSignaturePayloadDone(signatureData))
                }
            case let .createSignaturePayloadDone(signarutePayload):
                state.signatureData = signarutePayload
                return .none
            default:
                return .none
            }
        }
    }

    public init() {}
}
