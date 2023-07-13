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
                }
            }
        }
    }
}
