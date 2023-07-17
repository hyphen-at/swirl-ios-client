import ComposableArchitecture
import Dependencies
import SwirlAuth
import SwirlBlockchain

public struct SignIn: ReducerProtocol {
    public struct State: Equatable {
        public var isAuthenticating: Bool = false
        public var isHyphenAuthenticateChecking: Bool = true

        public init() {}
    }

    public enum Action {
        case onHyphenAuthenticateChecking

        case onLoggedIn
        case onSignInNeed

        case onContinueWithGoogleButtonClick

        case onNameCardCreateNeed
        case goToNameCardList

        case onError
    }

    @Dependency(\.swirlAuthClient) var authClient
    @Dependency(\.swirlBlockchainClient) var blockchainClient

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onHyphenAuthenticateChecking:
                return .run { dispatch in
                    if authClient.isHyphenLoggedIn() {
                        try await Task.sleep(nanoseconds: 1_000_000_000)
                        await dispatch(.onLoggedIn)
                    } else {
                        await dispatch(.onSignInNeed)
                    }
                }
            case .onLoggedIn:
                return .run { dispatch in
                    try await blockchainClient.fetchFlowAccount()

                    let myProfile = try await blockchainClient.getMyNameCard()

                    if myProfile == nil {
                        await dispatch(.onNameCardCreateNeed)
                    } else {
                        await dispatch(.goToNameCardList)
                    }
                }
            case .onSignInNeed:
                state.isHyphenAuthenticateChecking = false
                return .none
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
            default:
                return .none
            }
        }
    }

    public init() {}
}
