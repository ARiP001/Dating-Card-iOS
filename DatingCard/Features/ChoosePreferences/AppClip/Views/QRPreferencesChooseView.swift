//
//  QRPreferencesChooseView.swift
//  DatingCard
//

import SwiftUI

struct QRPreferencesChooseView: View {
    @Binding var selectedTopicIDs: Set<Int>

    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.xl) {
                    header

                    TopicFlowLayout(spacing: Spacing.sm) {
                        ForEach(Topics.all) { topic in
                            TopicChip(
                                title: topic.name,
                                isSelected: selectedTopicIDs.contains(topic.id)
                            ) {
                                toggle(topic.id)
                            }
                        }
                    }
                }
                .padding(.horizontal, Spacing.xl)
                .padding(.top, Spacing.xxl)
                .padding(.bottom, Spacing.lg)
            }
            .scrollBounceBehavior(.basedOnSize)

            AppButton(
                title: "Lanjut",
                isEnabled: !selectedTopicIDs.isEmpty,
                action: onContinue
            )
            .padding(.horizontal, Spacing.xl)
            .padding(.vertical, Spacing.lg)
        }
        .background(Color.bgPrimary.ignoresSafeArea())
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Apa yang ingin kamu ketahui\ntentang satu sama lain?")
                .font(AppFont.title3Bold)
                .foregroundStyle(Color.textPrimary)

            Text(
                "Pilihanmu akan jadi referensi topik pertanyaan untuk obrolan kalian nanti."
            )
            .font(AppFont.bodyRegular)
            .foregroundStyle(Color.textSecondary)
            .fixedSize(horizontal: false, vertical: true)
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

struct TopicFlowLayout: Layout {
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
                proposal: ProposedViewSize(
                    width: size.width,
                    height: size.height
                )
            )

            currentX += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

//#Preview {
//    @Previewable @State var selectedTopicIDs: Set<Int> = [2, 7, 19]
//
//    QRPreferencesChooseView(
//        selectedTopicIDs: $selectedTopicIDs,
//        onContinue: { }
//    )
//}
