import ComposableArchitecture
import SwirlSignInFeature

struct SwirlRoot: ReducerProtocol {
    enum State: Equatable {
        case signIn(SignIn.State)
    }

    enum Action {
        case signIn(SignIn.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        Scope(state: /State.signIn, action: /Action.signIn) {
            SignIn()
        }
    }
}
