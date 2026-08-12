//
//  CardStackIllustration.swift
//  DatingCard
//

import SwiftUI

struct CardStackIllustration: View {
    var width: CGFloat = 112
    var height: CGFloat = 148

    var body: some View {
        ZStack {
            card(color: Color.brandPrimaryRosePink)
                .rotationEffect(.degrees(-9))
                .offset(x: -14, y: 8)

            card(color: Color.accentDarkTaupe)
                .rotationEffect(.degrees(7))
                .offset(x: 14, y: 8)

            card(color: Color.accentDustyMauve)
        }
        .frame(
            width: width + Spacing.xl,
            height: height + Spacing.lg
        )
        .accessibilityHidden(true)
    }

    private func card(color: Color) -> some View {
        RoundedRectangle(cornerRadius: Radius.sm)
            .fill(color)
            .overlay {
                RoundedRectangle(cornerRadius: Radius.sm)
                    .stroke(Color.border, lineWidth: 1)
            }
            .frame(width: width, height: height)
            .shadow(
                color: Color.textPrimary.opacity(0.08),
                radius: 4,
                y: 2
            )
    }
}

#Preview {
    CardStackIllustration()
        .padding(Spacing.xxl)
        .background(Color.bgPrimary)
}
