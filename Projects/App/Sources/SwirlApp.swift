import ComposableArchitecture
import SwiftUI
import TCACoordinators

struct SwirlApp: View {
    let store: StoreOf<SwirlCoordinator>

    @State private var isFadeInTransitionUsing: Bool = false

    var body: some View {
        TCARouter(store) { screen in
            SwitchStore(screen) {
                switch $0 {
                case .sample:
                    CaseLet(
                        state: /SwirlRoot.State.sample,
                        action: SwirlRoot.Action.sample,
                        then: SampleScreen.init
                    )
                }
            }
        }
    }
}
