import SwiftUI

public struct SwirlNameCard: View {
    let name: String
    let profileUrl: String
    let date: Date
    let location: String
    let color: Color
    let enablePressAnimation: Bool
    let onClick: () -> Void

    public init(
        name: String,
        profileUrl: String,
        date: Date,
        location: String,
        color: Color,
        enablePressAnimation: Bool = true,
        onClick: @escaping () -> Void
    ) {
        self.name = name
        self.profileUrl = profileUrl
        self.date = date
        self.location = location
        self.color = color
        self.enablePressAnimation = enablePressAnimation
        self.onClick = onClick
    }

    @GestureState private var press: Bool = false
    @State private var isButtonPressed: Bool = false

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
                name: name,
                profileUrl: profileUrl,
                formattedTime: formattedTime,
                location: location
            )
            .background(color)
            .clipShape(CustomRoundedCorner(radius: 24, corners: [.topRight, .bottomLeft, .bottomRight]))
            .offset(x: 4, y: 4)

            SwirlNameCardContent(
                name: name,
                profileUrl: profileUrl,
                formattedTime: formattedTime,
                location: location
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

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(name)
                    .font(
                        Font.custom("PP Object Sans", size: 32)
                            .weight(.medium)
                    )
                    .foregroundColor(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor)
                    .padding(.leading, 16)
                Spacer()
                SwirlDesignSystemAsset.Images.cardDefaultProfile.swiftUIImage
                    .frame(width: 48, height: 48)
                    .padding(12)
            }
            .padding(.bottom, 82)
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
            SwirlNameCard(
                name: "Daniel",
                profileUrl: "",
                date: Date(),
                location: "LA, United States",
                color: Color(red: 0.93, green: 0.42, blue: 0.41),
                onClick: {}
            )
            .padding()
        }
    }
#endif
