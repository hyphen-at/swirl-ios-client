import SwiftUI

public struct AnyShape: Shape {
    private var base: (CGRect) -> Path

    public init(shape: some Shape) {
        base = shape.path(in:)
    }

    public func path(in rect: CGRect) -> Path {
        base(rect)
    }
}
