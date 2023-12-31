import ComposableArchitecture
import Feature
import PartialSheet
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
                        /SwirlRoot.State.signIn,
                        action: SwirlRoot.Action.signIn,
                        then: SignInScreen.init
                    )
                case .signInConfirmation:
                    CaseLet(
                        /SwirlRoot.State.signInConfirmation,
                        action: SwirlRoot.Action.signInConfirmation,
                        then: SignInConfirmationScreen.init
                    )
                case .makeProfile:
                    CaseLet(
                        /SwirlRoot.State.makeProfile,
                        action: SwirlRoot.Action.makeProfile,
                        then: MakeProfileScreen.init
                    )
                case .nameCardList:
                    CaseLet(
                        /SwirlRoot.State.nameCardList,
                        action: SwirlRoot.Action.nameCardList,
                        then: NameCardListScreen.init
                    )
                case .nameCardDetail:
                    CaseLet(
                        /SwirlRoot.State.nameCardDetail,
                        action: SwirlRoot.Action.nameCardDetail,
                        then: NameCardDetailScreen.init
                    )
                }
            }
        }
        .attachPartialSheetToRoot()
        .tint(.black)
    }
}
