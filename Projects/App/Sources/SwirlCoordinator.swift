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
        Reduce { _, action in
            switch action {
            default:
                return .none
            }
        }
        .forEachRoute {
            SwirlRoot()
        }
    }
}
