//
//  HistorySessionCard.swift
//  DatingCard
//

import SwiftUI

struct HistorySessionCard: View {
    let title: String
    let date: String
    var isContinue: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(title)
                    .font(AppFont.bodyBold)
                    .foregroundStyle(isContinue ? Color.bgCard : Color.textPrimary)
                    .lineLimit(1)

                Text(date)
                    .font(AppFont.caption2Regular)
                    .foregroundStyle(isContinue ? Color.bgCard.opacity(0.8) : Color.textSecondary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.md)
            .background(isContinue ? Color.accentPrimary : Color.bgCard)
            .clipShape(RoundedRectangle(cornerRadius: Radius.md))
            .overlay {
                if !isContinue {
                    RoundedRectangle(cornerRadius: Radius.md)
                        .stroke(Color.border, lineWidth: 1)
                }
            }
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
            date: "21 Juli 2026 | Belum Selesai",
            isContinue: true
        ) { }

        HistorySessionCard(
            title: "Cafe Hangout",
            date: "13 Juni 2026 | Selesai",
            isContinue: false
        ) { }
    }
    .padding(Spacing.md)
    .background(Color.bgPrimary)
}
