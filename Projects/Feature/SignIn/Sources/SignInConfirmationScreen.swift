import ComposableArchitecture
import HyphenCore
import SwiftUI
import SwirlDesignSystem

public struct SignInConfirmationScreen: View {
    let store: StoreOf<SignInConfirmation>

    public init(store: StoreOf<SignInConfirmation>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { _ in
            VStack(spacing: 0) {
                HStack {
                    if let appIcon = Bundle.main.icon {
                        Image(uiImage: appIcon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .inset(by: 0.5)
                                    .stroke(Color(red: 0.74, green: 0.76, blue: 0.79), lineWidth: 1)
                            )
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 26)
                HStack {
                    Text(SwirlSignInFeatureStrings.checkYourDevice(HyphenDeviceInformation.modelName))
                        .font(
                            Font.custom("PP Object Sans", size: 24)
                                .weight(.medium)
                        )
                        .foregroundColor(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor)
                        .padding(.top, 16)
                        .padding(.horizontal, 20)
                    Spacer()
                }
                Text(SwirlSignInFeatureStrings.checkYourDeviceDescription(HyphenDeviceInformation.modelName))
                    .font(.system(size: 16))
                    .foregroundColor(Color(red: 0.34, green: 0.34, blue: 0.34))
                    .padding(.top, 14)
                    .padding(.horizontal, 20)
                Spacer()
                SwirlButton(
                    label: SwirlSignInFeatureStrings.accessErrorDeviceButton,
                    onClick: {}
                )
                .padding(.horizontal, 16)
                Button(action: {}) {
                    Text(SwirlSignInFeatureStrings.requireAgain)
                        .font(.system(size: 16))
                        .underline()
                        .foregroundColor(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor.opacity(0.6))
                }
                .padding(.top, 20)
                .padding(.bottom, 24)
            }
        }
    }
}
