import NetworkImage
import SwiftUI
import SwirlModel

public struct SwirlNameCard: View {
    let profile: SwirlProfile
    let isMyProfile: Bool
    let hideMet: Bool
    let enablePressAnimation: Bool
    let onClick: () -> Void

    public init(
        profile: SwirlProfile,
        isMyProfile: Bool = false,
        hideMet: Bool = true,
        enablePressAnimation: Bool = true,
        onClick: @escaping () -> Void
    ) {
        self.profile = profile
        self.enablePressAnimation = enablePressAnimation
        self.hideMet = hideMet
        self.isMyProfile = isMyProfile
        self.onClick = onClick
    }

    @GestureState private var press: Bool = false
    @State private var isButtonPressed: Bool = false

    public var body: some View {
        ZStack {
            var formattedTime: String {
                let formatter = DateFormatter()
                // formatter.dateFormat = "MMM dd yyyy h:mma"
                formatter.dateFormat = "MMM dd yyyy"
                formatter.amSymbol = "AM"
                formatter.pmSymbol = "PM"

                let dateString = formatter.string(from: Date())
                let dayComponent = Calendar.current.component(.day, from: Date())
                let suffix: String

                switch dayComponent {
                case 1, 21, 31:
                    suffix = "st"
                case 2, 22:
                    suffix = "nd"
                case 3, 23:
                    suffix = "rd"
                default:
                    suffix = "th"
                }

                return dateString.replacingOccurrences(of: " \(dayComponent) ", with: " \(dayComponent)\(suffix), ")
            }

            SwirlNameCardContent(
                profile: profile,
                isMyProfile: isMyProfile,
                hideMet: hideMet,
                formattedTime: formattedTime
            )
            .background(Color(hex: profile.color))
            .clipShape(CustomRoundedCorner(radius: 24, corners: [.topRight, .bottomLeft, .bottomRight]))
            .offset(x: 4, y: 4)

            SwirlNameCardContent(
                profile: profile,
                isMyProfile: isMyProfile,
                hideMet: hideMet,
                formattedTime: formattedTime
            )
            .background(.white)
            .clipShape(CustomRoundedCorner(radius: 24, corners: [.topRight, .bottomLeft, .bottomRight]))
            .offset(x: press ? -1 : -4, y: press ? -1 : -4)
            .gesture(
                enablePressAnimation ? LongPressGesture(minimumDuration: 5, maximumDistance: 50)
                    .updating($press) { currentState, gestureState, _ in
                        gestureState = currentState
                    } : nil
            )
            .animation(.easeInOut, value: press)
        }
    }
}

private struct SwirlNameCardContent: View {
    let profile: SwirlProfile
    let isMyProfile: Bool
    let hideMet: Bool
    let formattedTime: String

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(profile.nickname)
                    .font(Font.custom("PP Object Sans", size: 40).weight(.medium))
                    .foregroundColor(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor)
                    .padding(.leading, 16)
                Spacer()

                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .aspectRatio(1, contentMode: .fit)

                    if !profile.profileImage.isEmpty {
                        if profile.profileImage == "default" {
                            SwirlDesignSystemAsset.Images.cardDefaultProfile.swiftUIImage
                                .resizable()
                        } else {
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
                            .id(profile)
                        }
                    }
                }
                .clipped()
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .inset(by: 0.5)
                        .stroke(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor, lineWidth: 1))
                .frame(width: 48, height: 48)
                .padding(12)
            }
            HStack {
                Text(SwirlDesignSystemStrings.myProfile)
                    .font(.system(size: 12))
                    .foregroundColor(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(red: 0.8, green: 0.8, blue: 0.8))
                    .cornerRadius(15)
                    .padding(.horizontal, 16)
                Spacer()
            }
            .padding(.bottom, isMyProfile && !hideMet ? 70 : 30)
            .opacity(isMyProfile ? 1.0 : 0.0)

            HStack(spacing: 0) {
                VStack(spacing: 8) {
                    HStack(spacing: 4) {
                        SwirlDesignSystemAsset.Icons.twitterLogo.swiftUIImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18)
                        Text(getHandle(profile.socialHandles.filter { $0.channel == "twitter" }.first))
                            .font(.system(size: 12))
                            .foregroundColor(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor)
                        Spacer()
                    }
                    .opacity((profile.socialHandles.first { $0.channel == "twitter" }?.handle.isEmpty ?? true) ? 0.2 : 1.0)
                    HStack(spacing: 4) {
                        SwirlDesignSystemAsset.Icons.discordLogo.swiftUIImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18)
                        Text(getHandle(profile.socialHandles.filter { $0.channel == "discord" }.first))
                            .font(.system(size: 12))
                            .foregroundColor(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor)
                        Spacer()
                    }
                    .opacity((profile.socialHandles.first { $0.channel == "discord" }?.handle.isEmpty ?? true) ? 0.2 : 1.0)
                }
                Spacer()
                VStack(spacing: 8) {
                    HStack(spacing: 4) {
                        SwirlDesignSystemAsset.Icons.telegramLogo.swiftUIImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18)
                        Text(getHandle(profile.socialHandles.filter { $0.channel == "telegram" }.first))
                            .font(.system(size: 12))
                            .foregroundColor(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor)
                        Spacer()
                    }
                    .opacity((profile.socialHandles.first { $0.channel == "telegram" }?.handle.isEmpty ?? true) ? 0.2 : 1.0)
                    HStack(spacing: 4) {
                        SwirlDesignSystemAsset.Icons.threadsLogo.swiftUIImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18)
                        Text(getHandle(profile.socialHandles.filter { $0.channel == "thread" }.first))
                            .font(.system(size: 12))
                            .foregroundColor(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor)
                        Spacer()
                    }
                    .opacity((profile.socialHandles.first { $0.channel == "thread" }?.handle.isEmpty ?? true) ? 0.2 : 1.0)
                }
                Spacer()
            }
            .padding(18)

            if !hideMet {
                VStack(spacing: 2) {
                    HStack(spacing: 0) {
                        Text(SwirlDesignSystemStrings.youMetAt)
                            .font(
                                Font.custom("PP Object Sans", size: 12)
                                    .weight(.bold)
                            )
                            .foregroundColor(Color(red: 0.09, green: 0.09, blue: 0.09))
                        Spacer()
                    }
                    HStack(spacing: 0) {
                        Text("\(formattedTime)")
//                        Text("<TIME NEED / LOCATION NEED>")
                            .font(.system(size: 12))
                            .foregroundColor(Color(red: 0.09, green: 0.09, blue: 0.09))
                        Spacer()
                    }
                    .padding(.bottom, 18)
                }
                .padding(.horizontal, 20)
            }
        }
        .customCornerRadius(24, corners: [.topRight, .bottomLeft, .bottomRight])
        .overlay(
            CustomRoundedCorner(radius: 24, corners: [.topRight, .bottomLeft, .bottomRight])
                .stroke(.black, lineWidth: 2)
        )
    }

    func getHandle(_ handle: SwirlProfile.SocialHandle?) -> String {
        if handle == nil {
            return "Not Set"
        }

        if handle!.handle.isEmpty {
            return "Not Set"
        } else {
            return handle!.handle
        }
    }
}

#if DEBUG
    struct SwirlNameCard_Previews: PreviewProvider {
        static var previews: some View {
            var profile: SwirlProfile {
                let mockSocialHandles = [
                    SwirlProfile.SocialHandle(channel: "twitter", handle: "@helloworld"),
                    SwirlProfile.SocialHandle(channel: "discord", handle: "helloworld"),
                    SwirlProfile.SocialHandle(channel: "telegram", handle: "helloworld"),
                    SwirlProfile.SocialHandle(channel: "threads", handle: "hihi.world"),
                ]

                let mockUser = SwirlProfile(
                    nickname: "HelloAlice",
                    profileImage: "https://...",
                    keywords: ["aa", "Blockchain", "loves", "you"],
                    color: "#deadbe",
                    socialHandles: mockSocialHandles
                )

                return mockUser
            }

            SwirlNameCard(
                profile: profile,
                onClick: {}
            )
            .padding()
        }
    }
#endif
