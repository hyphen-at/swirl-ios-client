import ComposableArchitecture

struct SwirlRoot: ReducerProtocol {
    enum State: Equatable {
        case sample(Sample.State)
    }

    enum Action {
        case sample(Sample.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        Scope(state: /State.sample, action: /Action.sample) {
            Sample()
        }
    }
}
