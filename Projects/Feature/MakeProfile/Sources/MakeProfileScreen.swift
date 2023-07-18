import ComposableArchitecture
import FCL_SDK
import SwiftUI
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

    @State var color: Color = .init(hue: Double.random(in: 0 ... 1), saturation: 0.62, brightness: 1)

    @State private var showingImagePicker = false
    @State private var inputImage: UIImage? = nil

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                VStack {
                    ScrollView {
                        if !viewStore.isEditMode {
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
                        }

                        ZStack {
                            MakeProfileCardContent(
                                nickname: $nickname,
                                twitterHandle: $twitterHandle,
                                discordHandle: $discordHandle,
                                telegramHandle: $telegramHandle,
                                threadsHandle: $threadsHandle,
                                keywords: $keywords,
                                isEditMode: viewStore.isEditMode,
                                pfpImage: inputImage,
                                onClick: { showingImagePicker = true }
                            )
                            .background(color)
                            .clipShape(CustomRoundedCorner(radius: 24, corners: [.topRight, .bottomLeft, .bottomRight]))
                            .offset(x: 4, y: 4)

                            MakeProfileCardContent(
                                nickname: $nickname.max(16),
                                twitterHandle: $twitterHandle,
                                discordHandle: $discordHandle,
                                telegramHandle: $telegramHandle,
                                threadsHandle: $threadsHandle,
                                keywords: $keywords.max(60),
                                isEditMode: viewStore.isEditMode,
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
                        UIApplication.shared.endEditing()
                        viewStore.send(.onMakeMyCardButtonClick(color))
                    }) {
                        HStack(alignment: .center, spacing: 10) {
                            Text(viewStore.isEditMode ? SwirlMakeProfileFeatureStrings.adjust : SwirlMakeProfileFeatureStrings.makeProfile)
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

                if viewStore.isLoading {
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
            .onAppear {
                if viewStore.isEditMode {
                    viewStore.send(.loadOriginalProfile)
                }
            }
            .animation(.easeInOut, value: viewStore.isLoading)
            .onChange(of: viewStore.originalProfile) { value in
                if let originalProfile = value {
                    nickname = originalProfile.nickname
                    twitterHandle = originalProfile.socialHandles.first { $0.channel == "twitter" }?.handle ?? ""
                    discordHandle = originalProfile.socialHandles.first { $0.channel == "discord" }?.handle ?? ""
                    threadsHandle = originalProfile.socialHandles.first { $0.channel == "thread" }?.handle ?? ""
                    telegramHandle = originalProfile.socialHandles.first { $0.channel == "telegram" }?.handle ?? ""

                    keywords = originalProfile.keywords.joined(separator: ", ")
                    color = Color(hex: originalProfile.color)!

                    guard let url = URL(string: originalProfile.profileImage) else {
                        print("Invalid URL")
                        return
                    }

                    let task = URLSession.shared.dataTask(with: url) { data, _, error in
                        if let error = error {
                            print("Error: \(error)")
                        } else if let data = data {
                            DispatchQueue.main.async {
                                if let image = UIImage(data: data) {
                                    inputImage = image
                                }
                            }
                        }
                    }

                    task.resume()
                }
            }
            .navigationBarTitle(Text(viewStore.isEditMode ? "Modify Profile" : ""))
            .navigationBarHidden(!viewStore.isEditMode)
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

    var isEditMode: Bool

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
                    onClick: {
                        UIApplication.shared.endEditing()
                        onClick()
                    }
                )
                .padding(.top, 8)

                if isEditMode {
                    Button(action: {
                        do {
                            let dapperWalletProvider = DapperWalletProvider.default
                            try fcl.config
                                .put(.network(.mainnet))
                                .put(.supportedWalletProviders(
                                    [
                                        dapperWalletProvider,
                                    ]
                                ))
                        } catch {
                            // handle error
                        }

                        Task {
                            do {
                                try await fcl.login()
                            } catch {}
                        }
                    }) {
                        HStack(spacing: 8) {
                            Spacer()
                            SwirlDesignSystemAsset.Icons.flowLogo.swiftUIImage
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)

                            Text("Connect Your Own Wallet")
                                .font(.system(size: 16))
                                .foregroundColor(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor)
                            Spacer()
                        }
                        .padding(.vertical, 12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(red: 0.09, green: 0.09, blue: 0.09), lineWidth: 1)
                        )
                        .background(Color(hex: "#31FD9C")!)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.top, 20)
                }
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

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
