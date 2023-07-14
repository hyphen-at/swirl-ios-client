import SwiftUI

public struct SwirlButton: View {
    let label: String
    let fontSize: Int
    let onClick: () -> Void

    public init(label: String, fontSize: Int = 16, onClick: @escaping () -> Void) {
        self.label = label
        self.fontSize = fontSize
        self.onClick = onClick
    }

    public var body: some View {
        Button(action: onClick) {
            HStack(spacing: 0) {
                Spacer()
                Text(label)
                    .font(.system(size: CGFloat(fontSize)))
                    .foregroundColor(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .inset(by: 0.5)
                    .stroke(SwirlDesignSystemAsset.Colors.defaultBlack.swiftUIColor, lineWidth: 1)
            )
        }
    }
}
