//
//  TopicRow.swift
//  DatingCard
//
//  Created by Arif Fathurrahman on 10/08/26.
//

import SwiftUI

struct TopicRow: View {

    enum Style {
        case normal
        case negative
    }

    let topic: ConversationTopic
    let isSelected: Bool

    var style: Style = .normal

    let action: () -> Void

    var body: some View {

        Button(
            action: action
        ) {

            HStack(spacing: 14) {

                Image(
                    systemName:
                        topic.systemImage
                )
                .frame(width: 26)

                Text(topic.title)
                    .font(
                        .body.weight(
                            .medium
                        )
                    )

                Spacer()

                Image(
                    systemName:
                        isSelected
                        ? "checkmark.circle.fill"
                        : "circle"
                )
                .font(.title3)
            }

            .foregroundStyle(
                isSelected
                ? selectedColor
                : Color.primary
            )

            .padding()

            .frame(
                maxWidth: .infinity
            )

            .background(
                backgroundColor
            )

            .clipShape(
                RoundedRectangle(
                    cornerRadius: 16,
                    style: .continuous
                )
            )
        }

        .buttonStyle(.plain)
    }

    private var selectedColor:
        Color {

        switch style {

        case .normal:
            return .brandPrimaryRosePink

        case .negative:
            return .red
        }
    }

    private var backgroundColor:
        Color {

        guard isSelected else {

            return Color
                .secondary
                .opacity(0.08)
        }

        switch style {

        case .normal:
            return Color
                .brandPrimaryRosePink
                .opacity(0.12)

        case .negative:
            return Color
                .red
                .opacity(0.10)
        }
    }
}
