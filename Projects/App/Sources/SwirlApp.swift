import ComposableArchitecture
import Feature
import SwiftUI
import TCACoordinators

struct SwirlApp: View {
    let store: StoreOf<SwirlCoordinator>

    var body: some View {
        TCARouter(store) { screen in
            SwitchStore(screen) {
                switch $0 {
                case .signIn:
                    CaseLet(
                        state: /SwirlRoot.State.signIn,
                        action: SwirlRoot.Action.signIn,
                        then: SignInScreen.init
                    )
                case .signInConfirmation:
                    CaseLet(
                        state: /SwirlRoot.State.signInConfirmation,
                        action: SwirlRoot.Action.signInConfirmation,
                        then: SignInConfirmationScreen.init
                    )
                case .makeProfile:
                    CaseLet(
                        state: /SwirlRoot.State.makeProfile,
                        action: SwirlRoot.Action.makeProfile,
                        then: MakeProfileScreen.init
                    )
                case .nameCardList:
                    CaseLet(
                        state: /SwirlRoot.State.nameCardList,
                        action: SwirlRoot.Action.nameCardList,
                        then: NameCardListScreen.init
                    )
                }
            }
        }
    }
}
