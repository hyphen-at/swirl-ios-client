import SwiftUI
import SwirlModel

public struct SwirlNameCard: View {
    let profile: SwirlProfile
    let isMyProfile: Bool
    let enablePressAnimation: Bool
    let onClick: () -> Void

    public init(
        profile: SwirlProfile,
        isMyProfile: Bool = false,
        enablePressAnimation: Bool = true,
        onClick: @escaping () -> Void
    ) {
        self.profile = profile
        self.enablePressAnimation = enablePressAnimation
        self.isMyProfile = isMyProfile
        self.onClick = onClick
    }

    @GestureState private var press: Bool = false
    @State private var isButtonPressed: Bool = false
    @State private var date: Date = randomDate()

    public var body: some View {
        ZStack {
            var formattedTime: String {
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM dd yyyy h:mma"
                formatter.amSymbol = "AM"
                formatter.pmSymbol = "PM"

                let dateString = formatter.string(from: date)
                let dayComponent = Calendar.current.component(.day, from: date)
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
                name: profile.nickname,
                profileUrl: profile.profileImage,
                formattedTime: formattedTime,
                location: "",
                isMyProfile: isMyProfile
            )
            .background(Color(hex: profile.color))
            .clipShape(CustomRoundedCorner(radius: 24, corners: [.topRight, .bottomLeft, .bottomRight]))
            .offset(x: 4, y: 4)

            SwirlNameCardContent(
                name: profile.nickname,
                profileUrl: profile.profileImage,
                formattedTime: formattedTime,
                location: "",
                isMyProfile: isMyProfile
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
    let name: String
    let profileUrl: String
    let formattedTime: String
    let location: String
    let isMyProfile: Bool

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(name)
                    .font(Font.custom("PP Object Sans", size: 40).weight(.medium))
                    .foregroundColor(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor)
                    .padding(.leading, 16)
                Spacer()
                SwirlDesignSystemAsset.Images.cardDefaultProfile.swiftUIImage
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
            .padding(.bottom, 89)
            .opacity(isMyProfile ? 1.0 : 0.0)
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
                    Text("\(formattedTime) @\(location)")
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 0.09, green: 0.09, blue: 0.09))
                    Spacer()
                }
                .padding(.bottom, 18)
            }
            .padding(.horizontal, 16)
        }
        .customCornerRadius(24, corners: [.topRight, .bottomLeft, .bottomRight])
        .overlay(
            CustomRoundedCorner(radius: 24, corners: [.topRight, .bottomLeft, .bottomRight])
                .stroke(.black, lineWidth: 2)
        )
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
