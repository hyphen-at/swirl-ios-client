import ComposableArchitecture
import SwiftUI
import SwiftUIIntrospect
import SwirlDesignSystem

public struct MakeProfileScreen: View {
    let store: StoreOf<MakeProfile>

    public init(
        store: StoreOf<MakeProfile>
    ) {
        self.store = store
    }

    @State var nickname: String = ""
    @State var twitterHandle: String = ""
    @State var discordHandle: String = ""
    @State var telegramHandle: String = ""
    @State var threadsHandle: String = ""
    @State var keywords: String = ""

    @State private var showingImagePicker = false
    @State private var inputImage: UIImage? = nil

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                ScrollView {
                    VStack(spacing: 0) {
                        HStack {
                            Text(SwirlMakeProfileFeatureStrings.letsMake)
                                .font(Font.custom("PP Object Sans", size: 32).weight(.medium))
                                .foregroundColor(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor)
                            Spacer()
                        }
                        .padding(.top, 8)
                        HStack {
                            Text(SwirlMakeProfileFeatureStrings.letsMakeDescription)
                                .font(.system(size: 14))
                                .foregroundColor(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor)
                            Spacer()
                        }
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 20)
                    ZStack {
                        MakeProfileCardContent(
                            nickname: $nickname,
                            twitterHandle: $twitterHandle,
                            discordHandle: $discordHandle,
                            telegramHandle: $telegramHandle,
                            threadsHandle: $threadsHandle,
                            keywords: $keywords,
                            pfpImage: inputImage,
                            onClick: { showingImagePicker = true }
                        )
                        .background(Color.red)
                        .clipShape(CustomRoundedCorner(radius: 24, corners: [.topRight, .bottomLeft, .bottomRight]))
                        .offset(x: 4, y: 4)

                        MakeProfileCardContent(
                            nickname: $nickname.max(16),
                            twitterHandle: $twitterHandle,
                            discordHandle: $discordHandle,
                            telegramHandle: $telegramHandle,
                            threadsHandle: $threadsHandle,
                            keywords: $keywords.max(60),
                            pfpImage: inputImage,
                            onClick: { showingImagePicker = true }
                        )
                        .background(Color.white)
                        .clipShape(CustomRoundedCorner(radius: 24, corners: [.topRight, .bottomLeft, .bottomRight]))
                        .offset(x: -4, y: -4)
                    }
                    .padding(16)
                }

                Spacer()

                Button(action: {
                    viewStore.send(.onMakeMyCardButtonClick)
                }) {
                    HStack(alignment: .center, spacing: 10) {
                        Text(SwirlMakeProfileFeatureStrings.makeProfile)
                            .font(Font.custom("PP Object Sans", size: 16).weight(.medium))
                            .foregroundColor(
                                viewStore.isValid ? Color.white :
                                    SwirlDesignSystemAsset.Colors.defaultGray.swiftUIColor
                            )
                    }
                }
                .disabled(!viewStore.isValid)
                .padding(.horizontal, 36)
                .padding(.vertical, 12)
                .background(!viewStore.isValid ? Color(red: 0.8, green: 0.8, blue: 0.8) : SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor)
                .cornerRadius(22)
                .padding(.bottom, 12)
                .animation(.easeIn, value: viewStore.isValid)
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .onChange(of: nickname) { value in
                viewStore.send(.updateNickname(value))
            }
            .onChange(of: twitterHandle) { value in
                viewStore.send(.updateTwitterHandle(value))
            }
            .onChange(of: discordHandle) { value in
                viewStore.send(.updateDiscordHandle(value))
            }
            .onChange(of: telegramHandle) { value in
                viewStore.send(.updateTelegramHandle(value))
            }
            .onChange(of: threadsHandle) { value in
                viewStore.send(.updateThreadsHandle(value))
            }
            .onChange(of: keywords) { value in
                viewStore.send(.updateKeywords(value))
            }
            .onChange(of: inputImage) { value in
                viewStore.send(.updatePfpImage(value))
            }
        }
    }
}

struct MakeProfileCardContent: View {
    @Binding var nickname: String
    @Binding var twitterHandle: String
    @Binding var discordHandle: String
    @Binding var telegramHandle: String
    @Binding var threadsHandle: String
    @Binding var keywords: String

    let pfpImage: UIImage?

    let onClick: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Group {
                HStack {
                    Text(SwirlMakeProfileFeatureStrings.makeProfileNickname)
                        .font(Font.custom("PP Object Sans", size: 12).weight(.bold))
                        .foregroundColor(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor)
                    Spacer()
                }
                SwirlTextField(text: $nickname, placeHolder: SwirlMakeProfileFeatureStrings.makeProfileNicknamePlaceholder)
                    .padding(.top, 8)
            }

            Group {
                HStack {
                    Text(SwirlMakeProfileFeatureStrings.makeProfileSocialHandle)
                        .font(Font.custom("PP Object Sans", size: 12).weight(.bold))
                        .foregroundColor(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor)
                    Spacer()
                }
                .padding(.top, 36)
                HStack(spacing: 12) {
                    SwirlDesignSystemAsset.Icons.twitterLogo.swiftUIImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18)
                    SwirlTextField(text: $twitterHandle, placeHolder: "Twitter_SWIRL")
                }
                .padding(.top, 8)
                HStack(spacing: 12) {
                    SwirlDesignSystemAsset.Icons.discordLogo.swiftUIImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18)
                    SwirlTextField(text: $discordHandle, placeHolder: "Discord_SWIRL")
                }
                .padding(.top, 8)
                HStack(spacing: 12) {
                    SwirlDesignSystemAsset.Icons.telegramLogo.swiftUIImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18)
                    SwirlTextField(text: $telegramHandle, placeHolder: "Telegram_SWIRL")
                }
                .padding(.top, 8)
                HStack(spacing: 12) {
                    SwirlDesignSystemAsset.Icons.threadsLogo.swiftUIImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18)
                    SwirlTextField(text: $threadsHandle, placeHolder: "Threads_SWIRL")
                }
                .padding(.top, 8)
            }

            Group {
                HStack {
                    Text(SwirlMakeProfileFeatureStrings.makeProfileKeywords)
                        .font(Font.custom("PP Object Sans", size: 20).weight(.bold))
                        .foregroundColor(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor)
                    Spacer()
                }
                .padding(.top, 36)
                SwirlTextField(
                    text: $keywords,
                    placeHolder: SwirlMakeProfileFeatureStrings.makeProfileKeywordsDescription,
                    lineLimit: 2
                )
                .padding(.top, 8)
            }

            Group {
                HStack {
                    Text(SwirlMakeProfileFeatureStrings.makeProfilePfp)
                        .font(Font.custom("PP Object Sans", size: 20).weight(.bold))
                        .foregroundColor(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor)
                    Spacer()
                }
                .padding(.top, 36)

                if let pfpImage = pfpImage {
                    ZStack {
                        Rectangle()
                            .fill(Color(.gray))
                            .aspectRatio(1, contentMode: .fit)

                        Image(uiImage: pfpImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .layoutPriority(-1)
                    }
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.top, 8)
                }

                SwirlButton(
                    label: pfpImage == nil ? SwirlMakeProfileFeatureStrings.makeProfilePfpCta : SwirlDesignSystemStrings.edit,
                    fontSize: 12,
                    onClick: onClick
                )
                .padding(.top, 8)
            }
        }
        .padding(16)
        .customCornerRadius(24, corners: [.topRight, .bottomLeft, .bottomRight])
        .overlay(
            CustomRoundedCorner(radius: 24, corners: [.topRight, .bottomLeft, .bottomRight])
                .stroke(.black, lineWidth: 2)
        )
    }
}
