import ComposableArchitecture
import MultipeerConnectivity
import NearbyInteraction
import SwiftUI
import SwiftUIIntrospect
import SwirlDesignSystem
import SwirlModel

public struct NameCardListScreen: View {
    let store: StoreOf<NameCardList>

    @State private var isShakeEnabled = false
    @StateObject private var deviceInteractor: SwirlDeviceInteractor = .init()

    public init(
        store: StoreOf<NameCardList>
    ) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                if viewStore.isLoading {
                    ProgressView()
                        .controlSize(.large)
                } else {
                    VStack {
                        HStack {
                            SwirlDesignSystemAsset.Images.swirlTextLogo.swiftUIImage
                                .resizable()
                                .scaledToFit()
                                .frame(height: 30)
                            Spacer()
                            Button(action: {}) {
                                SwirlDesignSystemAsset.Images.cardDefaultProfile.swiftUIImage
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40)
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 13)

                        SwirlCardStackView(
                            profiles: .constant(viewStore.profiles),
                            onNameCardClick: { profile in
                                viewStore.send(.onNameCardClick(profile: profile))
                            }
                        )

                        Button(action: {}) {
                            HStack(alignment: .center, spacing: 10) {
                                Text(SwirlNameCardListFeatureStrings.tutorialCta)
                                    .font(Font.custom("PP Object Sans", size: 16).weight(.medium))
                                    .foregroundColor(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .cornerRadius(22)
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .inset(by: 0.5)
                                .stroke(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor, lineWidth: 1)
                        )
                        .padding(.bottom, 12)
                    }
                    .opacity(isShakeEnabled ? 0 : 1)
                }

                if isShakeEnabled {
                    VStack(spacing: 0) {
                        Spacer()
                        HStack {
                            Spacer()
                            Text(SwirlNameCardListFeatureStrings.readyToSwirl)
                                .font(Font.custom("PP Object Sans", size: 28).weight(.medium))
                                .multilineTextAlignment(.center)
                                .foregroundColor(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor)
                            Spacer()
                        }
                        SwirlNameCard(
                            profile: viewStore.profiles.first!,
                            isMyProfile: true,
                            onClick: {}
                        )
                        .padding(.top, 60)
                        .padding(.horizontal, 12)
                        Button(action: {
                            isShakeEnabled = false

                            let generator = UINotificationFeedbackGenerator()
                            generator.notificationOccurred(.success)
                        }) {
                            SwirlNameCardListFeatureAsset.xButton.swiftUIImage
                                .resizable()
                                .scaledToFit()
                                .frame(width: 44)
                        }
                        .padding(.top, 156)
                        Spacer()
                    }
                    .background(
                        Color(red: 0.43, green: 0.95, blue: 0.91)
                            .opacity(0.3)
                    )
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.success)

                        deviceInteractor.startup()
                    }
                }
            }
            .onAppear {
                viewStore.send(.loading)
            }
            .onShake {
                if isShakeEnabled {
                    return
                }

                isShakeEnabled = true
            }
            .animation(.easeInOut, value: viewStore.isLoading)
            .animation(.easeInOut, value: isShakeEnabled)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}
