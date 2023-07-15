import ComposableArchitecture
import Dependencies
import SwirlAuth

public struct SignIn: ReducerProtocol {
    public struct State: Equatable {
        public init() {}
    }

    public enum Action {
        case onContinueWithGoogleButtonClick
    }

    @Dependency(\.swirlAuthClient) var authClient

    public var body: some ReducerProtocol<State, Action> {
        Reduce { _, action in
            switch action {
            case .onContinueWithGoogleButtonClick:
                return .run { _ in
                    try await authClient.signInWithGoogle()
                }
            }
        }
    }

    public init() {}
}
