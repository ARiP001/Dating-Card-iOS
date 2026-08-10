//
//  HistorySessionCard.swift
//  DatingCard
//

import SwiftUI

struct HistorySessionCard: View {
    let title: String
    let date: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(title)
                    .font(AppFont.bodyBold)
                    .foregroundStyle(Color.bgCard)
                    .lineLimit(1)

                Text(date)
                    .font(AppFont.caption2Regular)
                    .foregroundStyle(Color.bgCard.opacity(0.8))
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.sm)
            .background(Color.accentPrimary)
            .clipShape(RoundedRectangle(cornerRadius: Radius.nonclickable))
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityHint("Buka detail sesi")
    }
}

#Preview {
    VStack(spacing: Spacing.sm) {
        HistorySessionCard(
            title: "Beach trip with her",
            date: "21 Juli 2026"
        ) { }

        HistorySessionCard(
            title: "Cafe Hangout",
            date: "13 Juni 2026"
        ) { }
    }
    .padding(Spacing.md)
    .background(Color.bgPrimary)
}
