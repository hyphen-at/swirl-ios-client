import ComposableArchitecture
import HyphenCore
import HyphenUI
import LookingGlassUI
import MultipeerConnectivity
import NearbyInteraction
import NetworkImage
import PartialSheet
import SwiftUI
import SwiftUIIntrospect
import SwirlDesignSystem
import SwirlModel

public struct NameCardListScreen: View {
    let store: StoreOf<NameCardList>

    @State private var isShakeEnabled = false
    @StateObject private var deviceInteractor: SwirlDeviceInteractor = .init()

    @State private var isMomentConfirmationSheetPresented: Bool = false

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

                            if let profile = viewStore.profiles.first {
                                Button(action: {
                                    Hyphen.shared.openKeyManager()
                                    // viewStore.send(.onProfileIconClick)
                                }) {
                                    ZStack {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.2))
                                            .aspectRatio(1, contentMode: .fit)

                                        NetworkImage(url: URL(string: profile.profileImage)!) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .layoutPriority(-1)
                                        } placeholder: {
                                            ZStack {
                                                ProgressView()
                                                    .controlSize(.mini)
                                            }
                                            .aspectRatio(1, contentMode: .fit)
                                            .clipped()
                                        }
                                    }
                                    .clipped()
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .inset(by: 0.5)
                                            .stroke(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor, lineWidth: 1))
                                    .frame(width: 40)
                                }
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 13)

                        SwirlCardStackView(
                            profiles: Binding(
                                get: { viewStore.profiles },
                                set: { _ in }
                            ),
                            onNameCardClick: { profile, index in
                                viewStore.send(
                                    .onNameCardClick(
                                        profile: profile,
                                        momentId: index == 0 ? UInt64(Int64(0)) : viewStore.moments[index - 1].id
                                    )
                                )
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
                    ZStack {
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
                            .padding(.horizontal, 8)
                            .parallax(multiplier: 10, maxOffset: 60)
                            .shimmer(color: Color(hex: viewStore.profiles.first!.color)!.opacity(0.9))
                            Button(action: {
                                isShakeEnabled = false

                                deviceInteractor.session?.invalidate()
                                deviceInteractor.mpc?.invalidate()
                                deviceInteractor.sessionClear()

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
                            Color(hex: viewStore.profiles.first!.color)
                                .opacity(0.3)
                        )
                        .edgesIgnoringSafeArea(.all)
                        .onChange(of: deviceInteractor.peerData) { value in
                            isMomentConfirmationSheetPresented = value != nil
                        }
                        .onAppear {
                            let generator = UINotificationFeedbackGenerator()
                            generator.notificationOccurred(.success)

                            deviceInteractor.startup(
                                myNameCard: viewStore.profiles.first!,
                                signaturePayload: viewStore.signatureData,
                                nonce: viewStore.nonce
                            )
                        }
                        .partialSheet(
                            isPresented: $isMomentConfirmationSheetPresented,
                            iPhoneStyle: PSIphoneStyle(
                                background: .solid(Color(hex: "#F3F7F8")!.opacity(0.97)),
                                handleBarStyle: .none,
                                cover: .enabled(.black.opacity(0.4)),
                                cornerRadius: 24
                            )
                        ) {
                            VStack {
                                Text(SwirlNameCardListFeatureStrings.confirmToSwirl)
                                    .font(.system(size: 24).weight(.medium))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.black)
                                    .padding(.top, 40)
                                Text(SwirlNameCardListFeatureStrings.confirmToSwirlDescription(deviceInteractor.peerData?.profile.nickname ?? ""))
                                    .font(.system(size: 13).weight(.medium))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.black)
                                    .padding(.top, 13)

                                if let peerData = deviceInteractor.peerData {
                                    SwirlNameCard(
                                        profile: peerData.profile,
                                        isMyProfile: false,
                                        hideMet: false,
                                        onClick: {}
                                    )
                                    .padding(.horizontal, 8)
                                    .padding(.top, 30)
                                }
                                Button(action: {
                                    viewStore.send(.startTransaction([deviceInteractor.myData!, deviceInteractor.peerData!]))
                                    isMomentConfirmationSheetPresented = false
                                }) {
                                    Text(SwirlDesignSystemStrings.confirm)
                                        .font(.system(size: 17))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 14)
                                        .background(Color(red: 0, green: 0.48, blue: 1))
                                        .cornerRadius(12)
                                        .padding(.top, 14)
                                }
                                .padding(.top, 30)
                                Button(action: {
                                    isMomentConfirmationSheetPresented = false
                                    isShakeEnabled = false

                                    deviceInteractor.session?.invalidate()
                                    deviceInteractor.mpc?.invalidate()
                                    deviceInteractor.sessionClear()

                                    let generator = UINotificationFeedbackGenerator()
                                    generator.notificationOccurred(.success)
                                }) {
                                    Text(SwirlDesignSystemStrings.cancel)
                                        .font(.system(size: 17))
                                }
                                .padding(.top, 14)
                                .padding(.bottom, 23)
                            }
                            .onDisappear {
                                if !viewStore.isTransactionProcessing {
                                    isShakeEnabled = false
                                }

                                deviceInteractor.session?.invalidate()
                                deviceInteractor.mpc?.invalidate()
                                deviceInteractor.sessionClear()

                                let generator = UINotificationFeedbackGenerator()
                                generator.notificationOccurred(.success)
                            }
                        }

                        if viewStore.isTransactionProcessing {
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
                            .background(.black.opacity(0.4))
                            .allowsHitTesting(false)
                            .onDisappear {
                                isShakeEnabled = false

                                deviceInteractor.session?.invalidate()
                                deviceInteractor.mpc?.invalidate()
                                deviceInteractor.sessionClear()

                                let generator = UINotificationFeedbackGenerator()
                                generator.notificationOccurred(.success)
                            }
                        }
                    }
                }
            }
            .onAppear {
                viewStore.send(.loading)
            }
            .onChange(of: viewStore.isLoading) { value in
                if !value {
                    UIView.setAnimationsEnabled(true)
                    viewStore.send(.createSignaturePayload)
                    viewStore.send(.startAutoRefresh)
                }
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
        .motionManager(updateInterval: 0.1, disabled: false)
    }
}
