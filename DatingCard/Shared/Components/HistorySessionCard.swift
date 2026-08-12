//
//  HistorySessionCard.swift
//  DatingCard
//

import SwiftUI

struct HistorySessionCard: View {
    let title: String
    let lastTopic: String
    let date: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: Spacing.md) {
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text(title)
                        .font(AppFont.headlineSemibold)
                        .foregroundStyle(Color.bgCard)
                        .lineLimit(1)

                    Text("Topik Terakhir :")
                        .font(AppFont.caption1Regular)
                        .foregroundStyle(Color.bgCard.opacity(0.8))

                    Text(lastTopic)
                        .font(AppFont.caption1Regular)
                        .foregroundStyle(Color.bgCard)
                        .lineLimit(1)
                        .padding(.horizontal, Spacing.md)
                        .padding(.vertical, Spacing.sm)
                        .frame(minWidth:100 ,maxWidth: .infinity)
                        .background(Color.neutralDarkCharcoal.opacity(0.18))
                        .clipShape(Capsule())
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .trailing, spacing: Spacing.sm) {
                    Text("Belum Selesai")
                        .font(AppFont.headlineSemibold)

                    Text(date)
                        .font(AppFont.caption1Regular)
                }
                .foregroundStyle(Color.bgCard)
                .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(Spacing.lg)
            .background(Color.accentPrimary)
            .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
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
            lastTopic: "What Matters To Me",
            date: "21-7-2026"
        ) { }
    }
    .padding(Spacing.md)
    .background(Color.bgPrimary)
}
