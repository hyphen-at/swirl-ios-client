import ComposableArchitecture
import SwirlSignInFeature
import TCACoordinators
import UIKit

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
            case .routeAction(_, action: .signIn(.onNameCardCreateNeed)):
                state.routes.push(.makeProfile(.init()))
                return .none
            case .routeAction(_, action: .signIn(.goToNameCardList)):
                UIView.setAnimationsEnabled(false)
                state.routes.push(.nameCardList(.init()))
                return .none
            case .routeAction(_, action: .makeProfile(.onMakeMyCardComplete)):
                state.routes.push(.nameCardList(.init()))
                return .none
            case .routeAction(_, action: .makeProfile(.onModifyMyCardComplete)):
                state.routes.pop()
                return .none
            case .routeAction(_, action: .signInConfirmation(.close)):
                state.routes.dismiss()

                return .run { [state = state] dispatch in
                    try await Task.sleep(nanoseconds: 1_000_000_000)

                    var newRoutes = state.routes
                    newRoutes.push(.makeProfile(.init()))

                    await dispatch(.updateRoutes(newRoutes))
                }
            case let .routeAction(_, action: .nameCardList(.onNameCardClick(profile: profile, momentId: momentId))):
                state.routes.presentSheet(.nameCardDetail(.init(profile: profile, momentId: momentId)))
                return .none
            case .routeAction(_, action: .nameCardList(.onProfileIconClick)):
                state.routes.push(.makeProfile(.init(isEditMode: true)))
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
