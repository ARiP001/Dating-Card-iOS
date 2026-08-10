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
            card
                .rotationEffect(.degrees(-9))
                .offset(x: -14, y: 8)

            card
                .rotationEffect(.degrees(7))
                .offset(x: 14, y: 8)

            RoundedRectangle(cornerRadius: Radius.sm)
                .fill(Color.surfaceSecondary)
                .overlay {
                    RoundedRectangle(cornerRadius: Radius.sm)
                        .stroke(Color.border, lineWidth: 1)
                }
                .frame(width: width, height: height)
        }
        .frame(width: width + Spacing.xl, height: height + Spacing.lg)
        .accessibilityHidden(true)
    }

    private var card: some View {
        RoundedRectangle(cornerRadius: Radius.sm)
            .fill(Color.bgCard)
            .overlay {
                RoundedRectangle(cornerRadius: Radius.sm)
                    .stroke(Color.border, lineWidth: 1)
            }
            .frame(width: width, height: height)
            .shadow(color: Color.textPrimary.opacity(0.08), radius: 4, y: 2)
    }
}

#Preview {
    CardStackIllustration()
        .padding(Spacing.xxl)
        .background(Color.bgPrimary)
}
