import ComposableArchitecture
import Dependencies
import UIKit

public struct NameCardList: ReducerProtocol {
    public struct State: Equatable {
        public var isLoading: Bool = true

        public init() {}
    }

    public enum Action {
        case loading
        case loadingComplete
    }

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .loading:
                return .run { dispatch in
                    try await Task.sleep(nanoseconds: 1_000_000_000)
                    await dispatch(.loadingComplete)
                }
            case .loadingComplete:
                state.isLoading = false
                return .none
            default:
                return .none
            }
        }
    }

    public init() {}
}
