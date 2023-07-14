import ComposableArchitecture
import SwiftUI
import SwiftUIIntrospect
import SwirlDesignSystem

public struct SignInScreen: View {
    let store: StoreOf<SignIn>

    @State private var randomName: String = ""
    @State private var randomLocation: String = ""
    @State private var randomDate: Date = .init()
    @State private var randomColor: Color = .black

    public init(store: StoreOf<SignIn>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
//            SwirlCardStackView(
//                cardCount: .constant(10)
//            )
//                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
                SwirlDesignSystemAsset.Images.swirlTextLogo.swiftUIImage
                    .resizable()
                    .frame(width: 147, height: 55)
                    .padding(.top, 64)
                SwirlNameCard(
                    name: randomName,
                    profileUrl: "",
                    date: randomDate,
                    location: randomLocation,
                    color: randomColor,
                    onClick: {}
                )
                .shadow(radius: 2)
                .padding(.top, 58)
                .padding(.horizontal, 32)
                .allowsHitTesting(false)
                Text(SwirlSignInFeatureStrings.slogan)
                    .font(
                        Font.custom("PP Object Sans", size: 16)
                            .weight(.medium)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor)
                    .padding(.top, 40)
                Spacer()
                SwirlLoginButton(loginMethod: .google) {
                    viewStore.send(.onContinueWithGoogleButtonClick)
                }
                .padding(.horizontal, 24)
                SwirlLoginButton(loginMethod: .apple) {}
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                Button(action: {}) {
                    Text(SwirlSignInFeatureStrings.recover)
                        .font(.system(size: 16))
                        .underline()
                        .foregroundColor(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor.opacity(0.6))
                }
                .padding(.top, 28)
                SwirlDesignSystemAsset.Images.hyphenLogo.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .padding(.top, 39)
                    .padding(.bottom, 8)
            }
        }
        .introspect(.navigationView(style: .stack), on: .iOS(.v16), scope: .ancestor) { navigationController in
            navigationController.isNavigationBarHidden = true
        }
        .onAppear {
            randomDate = SwirlSignInFeature.randomDate()
            randomLocation = SwirlSignInFeature.randomLocation()
            randomName = SwirlSignInFeature.randomFakeFirstName()
            randomColor = Color(hue: Double.random(in: 0 ... 1), saturation: 0.62, brightness: 1)

            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
                withAnimation {
                    randomDate = SwirlSignInFeature.randomDate()
                    randomLocation = SwirlSignInFeature.randomLocation()
                    randomName = SwirlSignInFeature.randomFakeFirstName()
                    randomColor = Color(hue: Double.random(in: 0 ... 1), saturation: 0.62, brightness: 1)
                }
            }
        }
    }
}
