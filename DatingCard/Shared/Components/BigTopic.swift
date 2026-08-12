//
//  BigTopic.swift
//  DatingCard
//

import SwiftUI

struct BigTopic: View {
    let title: String
    let topics: [TopicModel]
    @Binding var selectedTopicIDs: Set<Int>
    var accentColor: Color = .accentPrimary

    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: Spacing.md) {
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text(title)
                            .font(AppFont.headlineSemibold)
                            .foregroundStyle(Color.textPrimary)

//                        Text(selectionSummary)
//                            .font(AppFont.caption1Regular)
//                            .foregroundStyle(Color.textSecondary)
                    }

                    Spacer(minLength: Spacing.md)

                    Image(systemName: "chevron.down")
                        .font(AppFont.headlineSemibold)
                        .foregroundStyle(accentColor)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .padding(Spacing.md)
            .accessibilityLabel(title)
//            .accessibilityValue(selectionSummary)
            .accessibilityHint(
                isExpanded ? "Tutup pilihan topik" : "Buka pilihan topik"
            )

            if isExpanded {
                Divider()
                    .padding(.horizontal, Spacing.md)

                BigTopicFlowLayout(spacing: Spacing.sm) {
                    ForEach(topics) { topic in
                        TopicChip(
                            title: topic.name,
                            isSelected: selectedTopicIDs.contains(topic.id),
                            accentColor: accentColor
                        ) {
                            toggle(topic.id)
                        }
                    }
                }
                .padding(Spacing.md)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Color.bgCard)
        .clipShape(
            RoundedRectangle(
                cornerRadius: Radius.md,
                style: .continuous
            )
        )
        .overlay {
            RoundedRectangle(
                cornerRadius: Radius.md,
                style: .continuous
            )
            .stroke(accentColor.opacity(0.45), lineWidth: 1)
        }
    }

    private var selectedCount: Int {
        topics.reduce(into: 0) { count, topic in
            if selectedTopicIDs.contains(topic.id) {
                count += 1
            }
        }
    }

//    private var selectionSummary: String {
//        selectedCount == 0
//        ? "Belum ada topik dipilih"
//        : "\(selectedCount) topik dipilih"
//    }

    private func toggle(_ topicID: Int) {
        if selectedTopicIDs.contains(topicID) {
            selectedTopicIDs.remove(topicID)
        } else {
            selectedTopicIDs.insert(topicID)
        }
    }
}

private struct BigTopicFlowLayout: Layout {
    let spacing: CGFloat

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        let availableWidth = proposal.width ?? .greatestFiniteMagnitude
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var rowHeight: CGFloat = 0
        var contentWidth: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)

            if currentX > 0,
               currentX + size.width > availableWidth {
                currentX = 0
                currentY += rowHeight + spacing
                rowHeight = 0
            }

            contentWidth = max(contentWidth, currentX + size.width)
            currentX += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }

        return CGSize(
            width: proposal.width ?? contentWidth,
            height: currentY + rowHeight
        )
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        var currentX = bounds.minX
        var currentY = bounds.minY
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)

            if currentX > bounds.minX,
               currentX + size.width > bounds.maxX {
                currentX = bounds.minX
                currentY += rowHeight + spacing
                rowHeight = 0
            }

            subview.place(
                at: CGPoint(x: currentX, y: currentY),
                anchor: .topLeading,
                proposal: ProposedViewSize(size)
            )

            currentX += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

#Preview {
    @Previewable @State var selectedTopicIDs: Set<Int> = [1, 3]

    BigTopic(
        title: "Identity",
        topics: Array(Topics.all.prefix(5)),
        selectedTopicIDs: $selectedTopicIDs,
        accentColor: .accentDustyMauve
    )
    .padding(Spacing.xl)
    .background(Color.bgPrimary)
}
