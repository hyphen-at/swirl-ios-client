import ComposableArchitecture
import SwiftUI
import SwiftUIIntrospect
import SwirlDesignSystem

public struct NameCardListScreen: View {
    let store: StoreOf<NameCardList>

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

                        SwirlCardStackView(cardCount: .constant(4))

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
                }
            }
            .onAppear {
                viewStore.send(.loading)
            }
            .animation(.easeInOut, value: viewStore.isLoading)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}
