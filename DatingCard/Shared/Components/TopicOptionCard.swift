//
//  TopicOptionCard.swift
//  DatingCard
//

import SwiftUI

struct TopicOptionCard<Value: Hashable>: View {
    let title: String
    let value: Value
    var icon: Image?
    var topicID: Int?
    var width: CGFloat = 250
    var height: CGFloat = 300
    @Binding var selection: Value?

    var body: some View {
        Button {
            selection = value
        } label: {
            VStack(spacing: Spacing.md) {
                if let icon {
                    icon
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: 44,
                            height: 44
                        )
                        .foregroundStyle(
                            foregroundColor
                        )
                }

                Text(title)
                    .font(AppFont.bodyBold)
                    .foregroundStyle(
                        foregroundColor
                    )
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .padding(Spacing.md)
            .frame(
                maxWidth: width == .infinity
                    ? .infinity
                    : width
            )
            .frame(height: height)
            .background(backgroundColor)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: Radius.sm
                )
            )
            .overlay {
                RoundedRectangle(cornerRadius: Radius.sm)
                    .stroke(
                        borderColor,
                        lineWidth: isSelected ? 4 : 2
                    )
            }
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(title)
        .accessibilityValue(
            isSelected
                ? "Dipilih"
                : "Belum dipilih"
        )
        .accessibilityHint(
            "Pilih topik untuk dibahas lebih dulu"
        )
    }

    private var isSelected: Bool {
        selection == value
    }

    private var foregroundColor: Color {
        isSelected
            ? .bgCard
            : .textPrimary
    }

    private var backgroundColor: Color {
        guard let topicID else {
            return isSelected
                ? .accentPrimary
                : .bgCard
        }

        return isSelected
            ? Color.topicColor(
                for: topicID
            )
            : Color.topicColor(
                for: topicID
            )
            .opacity(0.32)
    }

    private var borderColor: Color {
        guard let topicID else {
            return isSelected
                ? .accentPrimary
                : .border
        }

        return Color.topicColor(
            for: topicID
        )
    }
}

#Preview {
    @Previewable @State var selection: String? = "thoughts"

    VStack(spacing: Spacing.md) {
        TopicOptionCard(
            title: "Tentang Diriku",
            value: "about-me",
            icon: Image(systemName: "person.fill"),
            topicID: 1,
            selection: $selection
        )

        TopicOptionCard(
            title: "Isi Pikiran",
            value: "thoughts",
            icon: Image(
                systemName: "brain.head.profile"
            ),
            topicID: 10,
            selection: $selection
        )
    }
    .padding(Spacing.md)
    .background(Color.bgPrimary)
}
