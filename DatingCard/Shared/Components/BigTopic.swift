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
                    Text(title)
                        .font(AppFont.headlineSemibold)
                        .foregroundStyle(Color.textPrimary)

                    Spacer(minLength: Spacing.md)

                    Image(systemName: "chevron.down")
                        .font(AppFont.headlineSemibold)
                        .foregroundStyle(accentColor)
                        .rotationEffect(
                            .degrees(isExpanded ? 180 : 0)
                        )
                }
                .frame(
                    maxWidth: .infinity,
                    minHeight: 76,
                    alignment: .leading
                )
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .padding(.horizontal, Spacing.md)
            .accessibilityLabel(title)
            .accessibilityHint(
                isExpanded
                    ? "Tutup pilihan topik"
                    : "Buka pilihan topik"
            )

            if isExpanded {
                Divider()
                    .padding(.horizontal, Spacing.md)

                BigTopicFlowLayout(
                    spacing: Spacing.sm
                ) {
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
                .transition(
                    .opacity
                        .combined(
                            with: .move(edge: .top)
                        )
                )
            }
        }
        .background(Color.bgCard)
        .clipShape(
            RoundedRectangle(
                cornerRadius: Radius.md,
                style: .continuous
            )
        )
    }

    private var selectedCount: Int {
        topics.reduce(into: 0) { count, topic in
            if selectedTopicIDs.contains(topic.id) {
                count += 1
            }
        }
    }

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
        let availableWidth =
            proposal.width ?? .greatestFiniteMagnitude

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

            contentWidth = max(
                contentWidth,
                currentX + size.width
            )

            currentX += size.width + spacing
            rowHeight = max(
                rowHeight,
                size.height
            )
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
                at: CGPoint(
                    x: currentX,
                    y: currentY
                ),
                anchor: .topLeading,
                proposal: ProposedViewSize(size)
            )

            currentX += size.width + spacing
            rowHeight = max(
                rowHeight,
                size.height
            )
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
