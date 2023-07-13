import ComposableArchitecture
import Dependencies

public struct SignIn: ReducerProtocol {
    public struct State: Equatable {
        public init() {}
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
