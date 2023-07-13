import ComposableArchitecture
import SwiftUI

public struct SignInScreen: View {
    let store: StoreOf<SignIn>

    public init(store: StoreOf<SignIn>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { _ in
            ZStack {
                Button("Login with Google", action: {
                    // viewStore.send(.onGoogleLoginButtonClick)
                })
            }
        }
    }
}
