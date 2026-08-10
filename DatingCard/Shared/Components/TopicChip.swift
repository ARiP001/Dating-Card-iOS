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
                .font(AppFont.caption1Regular)
                .foregroundStyle(isSelected ? Color.bgCard : Color.textSecondary)
                .lineLimit(1)
                .padding(.horizontal, Spacing.md)
                .padding(.vertical, Spacing.sm)
                .background(isSelected ? Color.accentPrimary : Color.bgCard)
                .clipShape(RoundedRectangle(cornerRadius: Radius.clickable))
                .overlay {
                    RoundedRectangle(cornerRadius: Radius.clickable)
                        .stroke(isSelected ? Color.accentPrimary : Color.border, lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityValue(isSelected ? "Dipilih" : "Belum dipilih")
    }
}

#Preview {
    VStack(alignment: .leading, spacing: Spacing.sm) {
        HStack(spacing: Spacing.sm) {
            TopicChip(title: "Love Language", isSelected: false) { }
            TopicChip(title: "Masa Depan", isSelected: true) { }
        }

        HStack(spacing: Spacing.sm) {
            TopicChip(title: "Daily Life", isSelected: true) { }
            TopicChip(title: "Perasaan", isSelected: false) { }
        }
    }
    .padding(Spacing.md)
    .background(Color.bgPrimary)
}
