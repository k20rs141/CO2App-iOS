//
//  SwiftUI.View+Modifier.swift
//

import SwiftUI

private struct TextModifier: ViewModifier {
    let color: Color
    let font: UIFont

    init(color: Color, fontSize: CGFloat, fontWeight: UIFont.Weight) {
        self.color = color
        font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
    }

    func body(content: Content) -> some View {
        content
            .font(Font(font))
            .foregroundStyle(color)
    }
}

private struct CardModifier: ViewModifier {
    let backgroundColor: Color
    let cornerRadius: CGFloat

    init(backgroundColor: Color, cornerRadius: CGFloat) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
    }

    func body(content: Content) -> some View {
        content
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(radius: 4)
    }
}

public extension View {
    func modifyText(color: Color, fontSize: CGFloat, fontWeight: UIFont.Weight) -> some View {
        modifier(TextModifier(color: color, fontSize: fontSize, fontWeight: fontWeight))
    }

    func modifyCardView(backgroundColor: Color, cornerRadius: CGFloat) -> some View {
        modifier(CardModifier(backgroundColor: backgroundColor, cornerRadius: cornerRadius))
    }
}
