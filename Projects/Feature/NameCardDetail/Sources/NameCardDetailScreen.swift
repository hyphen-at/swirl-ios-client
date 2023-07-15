import ComposableArchitecture
import MapKit
import NetworkImage
import SwiftUI
import SwirlDesignSystem
import SwirlModel

public struct NameCardDetailScreen: View {
    let store: StoreOf<NameCardDetail>

    public init(store: StoreOf<NameCardDetail>) {
        self.store = store
    }

    @State private var region: MKCoordinateRegion = .init(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack(alignment: .top) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        ZStack {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .aspectRatio(1, contentMode: .fit)

                            NetworkImage(url: URL(string: "https://picsum.photos/1024/1024")!) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .layoutPriority(-1)
                            } placeholder: {
                                ZStack {
                                    ProgressView()
                                        .controlSize(.large)
                                }
                                .aspectRatio(1, contentMode: .fit)
                                .clipped()
                            }
                        }
                        .clipped()
                        HStack {
                            Text(viewStore.profile.nickname)
                                .font(Font.custom("PP Object Sans", size: 44).weight(.medium))
                                .foregroundColor(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor)
                                .padding(.top, 16)
                                .padding(.horizontal, 20)
                            Spacer()
                        }
                        Group {
                            SwirlFlowLayout(
                                mode: .scrollable,
                                items: ["Some long item here", "And then some longer one",
                                        "Short", "Items", "Here", "And", "A", "Few", "More",
                                        "And then a very very very long one"],
                                itemSpacing: 2
                            ) {
                                Text($0)
                                    .font(Font.custom("PP Object Sans", size: 16).weight(.medium))
                                    .foregroundColor(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color(hex: viewStore.profile.color))
                                    .cornerRadius(16)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .inset(by: 0.5)
                                            .stroke(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor, lineWidth: 1)
                                    )
                                    .contentShape(Rectangle())
                            }
                            .padding(.top, 24)
                            .padding(.horizontal, 18)
                        }
                        Group {
                            HStack {
                                Text(SwirlNameCardDetailFeatureStrings.socialHandles)
                                    .font(Font.custom("PP Object Sans", size: 16).weight(.medium))
                                    .foregroundColor(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor)
                                Spacer()
                            }
                            .padding(.top, 32)
                            HStack(spacing: 0) {
                                VStack(spacing: 4) {
                                    HStack(spacing: 4) {
                                        SwirlDesignSystemAsset.Icons.twitterLogo.swiftUIImage
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 18)
                                        Text(viewStore.profile.socialHandles.filter { $0.channel == "twitter" }.first?.handle ?? "")
                                            .font(.system(size: 12))
                                            .foregroundColor(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor)
                                        Spacer()
                                    }
                                    HStack(spacing: 4) {
                                        SwirlDesignSystemAsset.Icons.discordLogo.swiftUIImage
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 18)
                                        Text(viewStore.profile.socialHandles.filter { $0.channel == "discord" }.first?.handle ?? "")
                                            .font(.system(size: 12))
                                            .foregroundColor(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor)
                                        Spacer()
                                    }
                                }
                                Spacer()
                                VStack(spacing: 4) {
                                    HStack(spacing: 4) {
                                        SwirlDesignSystemAsset.Icons.telegramLogo.swiftUIImage
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 18)
                                        Text(viewStore.profile.socialHandles.filter { $0.channel == "telegram" }.first?.handle ?? "")
                                            .font(.system(size: 12))
                                            .foregroundColor(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor)
                                        Spacer()
                                    }
                                    HStack(spacing: 4) {
                                        SwirlDesignSystemAsset.Icons.threadsLogo.swiftUIImage
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 18)
                                        Text(viewStore.profile.socialHandles.filter { $0.channel == "threads" }.first?.handle ?? "")
                                            .font(.system(size: 12))
                                            .foregroundColor(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor)
                                        Spacer()
                                    }
                                }
                                Spacer()
                            }
                            .padding(.top, 10)
                        }
                        .padding(.horizontal, 20)

                        Group {
                            HStack {
                                Text(SwirlNameCardDetailFeatureStrings.yourMemories(viewStore.profile.nickname))
                                    .font(Font.custom("PP Object Sans", size: 16).weight(.medium))
                                    .foregroundColor(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor)
                                Spacer()
                            }
                            .padding(.top, 32)
                            ZStack {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .aspectRatio(1.179, contentMode: .fit)

                                NetworkImage(url: URL(string: "https://picsum.photos/1340/1136")!) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .layoutPriority(-1)
                                } placeholder: {
                                    ZStack {
                                        ProgressView()
                                            .controlSize(.large)
                                    }
                                    .aspectRatio(1, contentMode: .fit)
                                    .clipped()
                                }
                            }
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.top, 8)
                        }
                        .padding(.horizontal, 20)

                        Group {
                            HStack {
                                Text(SwirlNameCardDetailFeatureStrings.location)
                                    .font(Font.custom("PP Object Sans", size: 16).weight(.medium))
                                    .foregroundColor(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor)
                                Spacer()
                            }
                            .padding(.top, 32)

                            Map(coordinateRegion: $region)
                                .aspectRatio(1.0, contentMode: .fill)
                                .disabled(true)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .padding(.top, 8)

                            HStack {
                                Text("June 18th, 2023 2:39PM")
                                    .font(.system(size: 12))
                                    .foregroundColor(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor)
                                    .padding(.top, 12)
                                Spacer()
                            }
                            HStack {
                                Text("Centro Luiz Gonzaga, Rio de Janeiro, Brazil")
                                    .font(.system(size: 12))
                                    .foregroundColor(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor)
                                    .padding(.top, 4)
                                    .padding(.bottom, 40)
                                Spacer()
                            }
                        }
                        .padding(.horizontal, 20)
                        VStack(alignment: .center, spacing: 0) {
                            HStack {
                                Spacer()
                                Text(SwirlNameCardDetailFeatureStrings.flowscanTitle(viewStore.profile.nickname))
                                    .font(Font.custom("PP Object Sans", size: 20).weight(.bold))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor)
                                Spacer()
                            }
                            Text(SwirlNameCardDetailFeatureStrings.flowscanSubtitle)
                                .font(.system(size: 14))
                                .multilineTextAlignment(.center)
                                .foregroundColor(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor)
                                .padding(.top, 16)

                            Button(action: {}) {
                                HStack(spacing: 12) {
                                    Spacer()
                                    SwirlDesignSystemAsset.Icons.flowLogo.swiftUIImage
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20)
                                    Text(SwirlNameCardDetailFeatureStrings.flowscanCta)
                                        .font(.system(size: 16))
                                        .foregroundColor(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor)
                                    Spacer()
                                }
                                .padding(.vertical, 12)
                                .background(Color(red: 0.19, green: 0.99, blue: 0.61))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .inset(by: 0.5)
                                        .stroke(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor, lineWidth: 1)
                                )
                                .padding(.horizontal, 28)
                                .padding(.top, 32)
                            }
                        }
                        .padding(.top, 28)
                        .padding(.bottom, 32)
                        .background(.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.16), radius: 8, x: 0, y: 2)
                        .padding(.horizontal, 20)
                        Spacer()
                    }
                }

                Rectangle()
                    .frame(width: 51, height: 6)
                    .foregroundColor(SwirlDesignSystemAsset.Colors.defaultGray.swiftUIColor.opacity(0.5))
                    .cornerRadius(3)
                    .padding(.top, 8)
            }
            .onAppear {
                region = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: viewStore.location.latitude, longitude: viewStore.location.longitude),
                    span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
                )
            }
        }
    }
}
