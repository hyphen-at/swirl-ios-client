import ComposableArchitecture
import Dependencies
import MapKit
import SwirlBlockchain
import SwirlModel
import UIKit

public struct NameCardDetail: ReducerProtocol {
    public struct State: Equatable {
        public var profile: SwirlProfile
        public var momentId: UInt64
        public var location: LatLng = .init(latitude: 37.5313792, longitude: 127.0089012)

        public var isMomentDeleteConfirmAlertPresented: Bool = false
        public var isFlowViewPresented: Bool = false

        public var isDeleting: Bool = false

        public var requestDismiss: Bool = false

        public var flowViewUrl: String = "https://testnet.flowview.app/account/"

        public init(
            profile: SwirlProfile,
            momentId: UInt64
        ) {
            self.profile = profile
            self.momentId = momentId
        }
    }

    public enum Action {
        case onFlowViewUrlLoadNeeded
        case setFlowViewPresented(Bool)

        case onProfileImageLongPress

        case onDeleteMomentConfirmAlertPresent(Bool)
        case onDeleteMomentConfirmed
        case onDeleteMomentComplete
    }

    @Dependency(\.swirlBlockchainClient) var blockchainClient

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onFlowViewUrlLoadNeeded:
                state.flowViewUrl = "\(state.flowViewUrl)/\(blockchainClient.getCachedAccountAddress())/collection/SwirlMomentCollection/\(state.momentId)"
                return .none
            case let .setFlowViewPresented(isPresented):
                state.isFlowViewPresented = isPresented
                return .none
            case .onProfileImageLongPress:
                state.isMomentDeleteConfirmAlertPresented = true
                return .none
            case let .onDeleteMomentConfirmAlertPresent(isPresented):
                state.isMomentDeleteConfirmAlertPresented = isPresented
                return .none
            case .onDeleteMomentConfirmed:
                state.isMomentDeleteConfirmAlertPresented = false
                state.isDeleting = true
                return .run { [state = state] dispatch in
                    try await blockchainClient.burnMoment(state.momentId)
                    await dispatch(.onDeleteMomentComplete)
                }
            case .onDeleteMomentComplete:
                state.isMomentDeleteConfirmAlertPresented = false
                state.requestDismiss = true
                return .none
            }
        }
    }

    public init() {}
}

// MARK: - Latitude, Longitude

public extension NameCardDetail {
    struct LatLng: Equatable {
        let latitude: Double
        let longitude: Double
    }
}
