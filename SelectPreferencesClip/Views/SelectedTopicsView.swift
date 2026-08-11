//
//  SelectedTopicsView.swift
//  SelectPreferencesClip
//

import SwiftUI

struct SelectedTopicsView: View {
    @Binding var selectedTopicIDs: Set<Int>

    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.xl) {
                    header

                    AppClipTopicFlowLayout(spacing: Spacing.sm) {
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
                .padding(.horizontal, Spacing.lg)
                .padding(.top, Spacing.xxl)
                .padding(.bottom, Spacing.lg)
            }

            AppButton(
                title: "Lanjut",
                isEnabled: !selectedTopicIDs.isEmpty,
                action: onContinue
            )
            .padding(.horizontal, Spacing.lg)
            .padding(.bottom, Spacing.lg)
        }
        .background(Color.bgPrimary.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Apa yang ingin kamu ketahui\ntentang satu sama lain?")
                .font(AppFont.title3Bold)
                .foregroundStyle(Color.textPrimary)

            Text("Pilihanmu akan jadi referensi topik\npertanyaan untuk obrolan kalian nanti.")
                .font(AppFont.bodyRegular)
                .foregroundStyle(Color.textSecondary)
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

/// Layout chip yang dipakai bersama oleh dua halaman pemilihan topik App Clip.
struct AppClipTopicFlowLayout: Layout {
    let spacing: CGFloat

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        let maximumWidth = proposal.width ?? .infinity
        var rowWidth: CGFloat = 0
        var rowHeight: CGFloat = 0
        var totalHeight: CGFloat = 0
        var contentWidth: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            let nextWidth = rowWidth == 0 ? size.width : rowWidth + spacing + size.width

            if nextWidth > maximumWidth, rowWidth > 0 {
                contentWidth = max(contentWidth, rowWidth)
                totalHeight += rowHeight + spacing
                rowWidth = size.width
                rowHeight = size.height
            } else {
                rowWidth = nextWidth
                rowHeight = max(rowHeight, size.height)
            }
        }

        contentWidth = max(contentWidth, rowWidth)
        totalHeight += rowHeight

        return CGSize(
            width: proposal.width ?? contentWidth,
            height: totalHeight
        )
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)

            if x > bounds.minX, x + size.width > bounds.maxX {
                x = bounds.minX
                y += rowHeight + spacing
                rowHeight = 0
            }

            subview.place(
                at: CGPoint(x: x, y: y),
                anchor: .topLeading,
                proposal: ProposedViewSize(size)
            )

            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

#Preview {
    SelectedTopicsView(
        selectedTopicIDs: .constant([2, 7, 19])
    ) { }
}
