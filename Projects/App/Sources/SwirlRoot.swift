import ComposableArchitecture
import SwirlSignInFeature

struct SwirlRoot: ReducerProtocol {
    enum State: Equatable {
        case signIn(SignIn.State)
        case signInConfirmation(SignInConfirmation.State)
    }

    enum Action {
        case signIn(SignIn.Action)
        case signInConfirmation(SignInConfirmation.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        Scope(state: /State.signIn, action: /Action.signIn) {
            SignIn()
        }
        Scope(state: /State.signInConfirmation, action: /Action.signInConfirmation) {
            SignInConfirmation()
        }
    }
}
