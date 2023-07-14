import ComposableArchitecture
import SwirlSignInFeature
import TCACoordinators

struct SwirlCoordinator: ReducerProtocol {
    struct State: Equatable, IndexedRouterState {
        var routes: [Route<SwirlRoot.State>] = [.root(.signIn(.init()), embedInNavigationView: true)]
    }

    enum Action: IndexedRouterAction {
        case routeAction(Int, action: SwirlRoot.Action)
        case updateRoutes([Route<SwirlRoot.State>])
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .routeAction(0, action: .signIn(.onContinueWithGoogleButtonClick)):
                state.routes.presentCover(.signInConfirmation(.init()))
                return .none
            default:
                return .none
            }
        }
        .forEachRoute {
            SwirlRoot()
        }
    }
}
