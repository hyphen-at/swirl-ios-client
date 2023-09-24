import ComposableArchitecture
import Dependencies

public struct SignInConfirmation: ReducerProtocol {
    public struct State: Equatable {
        public init() {}
    }

    public enum Action {
        case close
    }

    public var body: some ReducerProtocol<State, Action> {
        Reduce { _, action in
            switch action {
            default:
                .none
            }
        }
    }

    public init() {}
}
