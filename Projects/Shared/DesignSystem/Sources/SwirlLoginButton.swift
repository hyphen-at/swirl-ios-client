import SwiftUI

public struct SwirlLoginButton: View {
    let loginMethod: LoginMethod
    let onClick: () -> Void

    public init(
        loginMethod: LoginMethod,
        onClick: @escaping () -> Void
    ) {
        self.loginMethod = loginMethod
        self.onClick = onClick
    }

    public var body: some View {
        Button(action: onClick) {
            HStack(spacing: 8) {
                Spacer()
                if loginMethod == .google {
                    SwirlDesignSystemAsset.Icons.googleLogo.swiftUIImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                } else {
                    SwirlDesignSystemAsset.Icons.appleLogo.swiftUIImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.gray)
                }

                if loginMethod == .google {
                    Text(SwirlDesignSystemStrings.loginGoogle)
                        .font(.system(size: 16))
                        .foregroundColor(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor)
                } else {
                    Text(SwirlDesignSystemStrings.loginApple)
                        .font(.system(size: 16))
                        .foregroundColor(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor)
                }
                Spacer()
            }
            .padding(.vertical, 12)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(red: 0.09, green: 0.09, blue: 0.09), lineWidth: 1)
            )
        }
    }

    public enum LoginMethod {
        case google
        case apple
    }
}

#if DEBUG
    struct SwirlLoginButton_Previews: PreviewProvider {
        static var previews: some View {
            VStack(spacing: 8) {
                SwirlLoginButton(loginMethod: .google) {}
                SwirlLoginButton(loginMethod: .apple) {}
            }
            .padding()
        }
    }
#endif
