//
//  TopicChip.swift
//  DatingCard
//

import SwiftUI

struct TopicChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFont.bodyRegular)
                .foregroundStyle(
                    isSelected
                    ? Color.bgCard
                    : Color.textPrimary
                )
                .lineLimit(1)
                .padding(.horizontal, Spacing.md)
                .frame(height: 35)
                .background(
                    isSelected
                    ? Color.accentPrimary
                    : Color.clear
                )
                .clipShape(Capsule())
                .overlay {
                    Capsule()
                        .stroke(
                            Color.accentPrimary,
                            lineWidth: 2
                        )
                }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityValue(
            isSelected
            ? "Dipilih"
            : "Belum dipilih"
        )
    }
}

#Preview {
    VStack(alignment: .leading, spacing: Spacing.md) {
        HStack(spacing: Spacing.sm) {
            TopicChip(
                title: "Love Language",
                isSelected: false
            ) { }

            TopicChip(
                title: "Masa Depan",
                isSelected: true
            ) { }
        }

        HStack(spacing: Spacing.sm) {
            TopicChip(
                title: "Daily Life",
                isSelected: false
            ) { }

            TopicChip(
                title: "Perasaan",
                isSelected: true
            ) { }
        }
    }
    .padding(Spacing.xl)
    .background(Color.bgPrimary)
}
