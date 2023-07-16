import ComposableArchitecture
import Dependencies
import SwirlAuth

public struct SignIn: ReducerProtocol {
    public struct State: Equatable {
        public var isAuthenticating: Bool = false
        
        public init() {}
    }

    public enum Action {
        case onContinueWithGoogleButtonClick
        
        case onError
    }

    @Dependency(\.swirlAuthClient) var authClient

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onContinueWithGoogleButtonClick:
                state.isAuthenticating = true
                return .run { dispatch in
                    do {
                        try await authClient.signInWithGoogle()
                    } catch {
                        await dispatch(.onError)
                    }
                }
            case .onError:
                state.isAuthenticating = false
                return .none
            }
        }
    }

    public init() {}
}
