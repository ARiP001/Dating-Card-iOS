//
//  TopicOptionCard.swift
//  DatingCard
//

import SwiftUI

struct TopicOptionCard<Value: Hashable>: View {
    let title: String
    let icon: Image
    let value: Value
    @Binding var selection: Value?

    var body: some View {
        Button {
            selection = value
        } label: {
            VStack(spacing: Spacing.md) {
                icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44, height: 44)
                    .foregroundStyle(foregroundColor)

                Text(title)
                    .font(AppFont.bodyBold)
                    .foregroundStyle(foregroundColor)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .padding(Spacing.md)
            .frame(width: 250, height: 300)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: Radius.sm))
            .overlay {
                RoundedRectangle(cornerRadius: Radius.sm)
                    .stroke(borderColor, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(title)
        .accessibilityValue(isSelected ? "Dipilih" : "Belum dipilih")
        .accessibilityHint("Pilih topik untuk dibahas lebih dulu")
    }

    private var isSelected: Bool {
        selection == value
    }

    private var foregroundColor: Color {
        isSelected ? .bgCard : .textPrimary
    }

    private var backgroundColor: Color {
        isSelected ? .accentPrimary : .bgCard
    }

    private var borderColor: Color {
        isSelected ? .accentPrimary : .border
    }
}

#Preview {
    @Previewable @State var selection: String? = "thoughts"

    VStack(spacing: Spacing.md) {
        TopicOptionCard(
            title: "Tentang Diriku",
            icon: Image(systemName: "person.fill"),
            value: "about-me",
            selection: $selection
        )

        TopicOptionCard(
            title: "Isi Pikiran",
            icon: Image(systemName: "brain.head.profile"),
            value: "thoughts",
            selection: $selection
        )
    }
    .padding(Spacing.md)
    .background(Color.bgPrimary)
}
