import SwiftUI

public struct SwirlTextField: View {
    @Binding var text: String
    let placeHolder: String
    let lineLimit: Int

    public init(
        text: Binding<String>,
        placeHolder: String,
        lineLimit: Int = 1
    ) {
        _text = text
        self.placeHolder = placeHolder
        self.lineLimit = lineLimit
    }

    public var body: some View {
        TextField(
            placeHolder,
            text: $text,
            prompt: Text(placeHolder).font(.system(size: 12))
        )
        .autocorrectionDisabled(true)
        .lineLimit(lineLimit)
        .padding(.horizontal, 12)
        .padding(.vertical, lineLimit > 1 ? 12 : 0)
        .frame(height: lineLimit > 1 ? 56 : 38, alignment: lineLimit > 1 ? .top : .center)
        .font(.system(size: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .inset(by: 0.5)
                .stroke(SwirlDesignSystemAsset.Colors.defaultGray.swiftUIColor, lineWidth: 1)
        )
        .contentShape(Rectangle())
    }
}
