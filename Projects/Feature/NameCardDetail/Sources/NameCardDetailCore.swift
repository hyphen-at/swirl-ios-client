import ComposableArchitecture
import Dependencies
import MapKit
import SwirlModel
import UIKit

public struct NameCardDetail: ReducerProtocol {
    public struct LatLng: Equatable {
        let latitude: Double
        let longitude: Double
    }

    public struct State: Equatable {
        public var profile: SwirlProfile
        public var momentId: UInt64
        public var location: LatLng = .init(latitude: 37.5313792, longitude: 127.0089012)

        public init(
            profile: SwirlProfile,
            momentId: UInt64
        ) {
            self.profile = profile
            self.momentId = momentId
        }
    }

    public enum Action {}

    public var body: some ReducerProtocol<State, Action> {
        Reduce { _, action in
            switch action {
            default:
                return .none
            }
        }
    }

    public init() {}
}
