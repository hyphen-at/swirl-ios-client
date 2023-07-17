import ComposableArchitecture
import SwiftUI
import SwiftUIIntrospect
import SwirlDesignSystem
import SwirlModel

public struct SignInScreen: View {
    let store: StoreOf<SignIn>

    @State private var randomName: String = randomFakeFirstName()
    @State private var randomLocation: String = ""
    @State private var randomDate: Date = .init()
    @State private var randomColor: Color = .black

    public init(store: StoreOf<SignIn>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                if viewStore.isHyphenAuthenticateChecking {
                    ProgressView()
                        .controlSize(.large)
                        .onAppear {
                            viewStore.send(.onHyphenAuthenticateChecking)
                        }
                } else {
                    VStack(spacing: 0) {
                        SwirlDesignSystemAsset.Images.swirlTextLogo.swiftUIImage
                            .resizable()
                            .frame(width: 147, height: 55)
                            .padding(.top, 64)
                        SwirlNameCard(
                            profile: SwirlProfile(
                                nickname: randomName,
                                profileImage: "default",
                                keywords: [""],
                                color: randomColor.toHex()!,
                                socialHandles: [
                                    SwirlProfile.SocialHandle(channel: "twitter", handle: "@helloworld"),
                                    SwirlProfile.SocialHandle(channel: "discord", handle: "helloworld"),
                                    SwirlProfile.SocialHandle(channel: "telegram", handle: "helloworld"),
                                    SwirlProfile.SocialHandle(channel: "thread", handle: "hihi.world"),
                                ]
                            ),
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

                    if viewStore.isAuthenticating {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                ProgressView()
                                    .controlSize(.large)
                                Spacer()
                            }
                            Spacer()
                        }
                        .background(.black.opacity(0.1))
                        .edgesIgnoringSafeArea(.all)
                    }
                }
            }
            .animation(.easeInOut, value: viewStore.isAuthenticating)
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
