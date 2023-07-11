import ComposableArchitecture
import Dependencies
import SwirlAuth

public struct Sample: ReducerProtocol {
    public struct State: Equatable {
        public init() {}
    }

    public enum Action {
        case onGoogleLoginButtonClick
    }

    @Dependency(\.swirlAuthClient) var authClient

    public var body: some ReducerProtocol<State, Action> {
        Reduce { _, action in
            switch action {
            case .onGoogleLoginButtonClick:
                return .run { _ in
                    try await authClient.signInWithGoogle()
                }
            default:
                return .none
            }
        }
    }

    public init() {}
}
