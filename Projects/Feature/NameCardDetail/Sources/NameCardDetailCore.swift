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
        public var isDeleting: Bool = false

        public var requestDismiss: Bool = false

        public init(
            profile: SwirlProfile,
            momentId: UInt64
        ) {
            self.profile = profile
            self.momentId = momentId
        }
    }

    public enum Action {
        case onProfileImageLongPress

        case onDeleteMomentConfirmAlertPresent(Bool)
        case onDeleteMomentConfirmed
        case onDeleteMomentComplete
    }

    @Dependency(\.swirlBlockchainClient) var blochchainClient

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
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
                    try await blochchainClient.burnMoment(state.momentId)
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
