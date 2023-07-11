import ComposableArchitecture
import SwiftUI

struct SampleScreen: View {
    let store: StoreOf<Sample>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                Button("Login with Google", action: {
                    viewStore.send(.onGoogleLoginButtonClick)
                })
            }
        }
    }
}
