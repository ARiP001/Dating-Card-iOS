//
//  SelectedTopicsView.swift
//  SelectPreferencesClip
//

import SwiftUI

struct SelectedTopicsView: View {
    @Binding var selectedTopicIDs: Set<Int>

    let onContinue: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.bgPrimary
                .ignoresSafeArea()

            Circle()
                .fill(
                    Color.brandPrimaryRosePink.opacity(0.25)
                )
                .frame(
                    width: 360,
                    height: 360
                )
                .blur(radius: 80)
                .offset(
                    x: 120,
                    y: -120
                )
                .allowsHitTesting(false)
                .accessibilityHidden(true)

            ScrollView {
                VStack(
                    alignment: .leading,
                    spacing: Spacing.xl
                ) {
                    header

                    AppClipTopicFlowLayout(
                        spacing: Spacing.sm
                    ) {
                        ForEach(Topics.all) { topic in
                            TopicChip(
                                title: topic.name,
                                isSelected: selectedTopicIDs.contains(topic.id),
                                accentColor: .brandPrimaryRosePink
                            ) {
                                toggle(topic.id)
                            }
                        }
                    }
                }
                .padding(.horizontal, Spacing.xl)
                .padding(.top, Spacing.md)
                .padding(.bottom, 120)
            }
            .scrollBounceBehavior(.basedOnSize)
        }
        .overlay(alignment: .bottom) {
            VStack {
                AppButton(
                    title: "Lanjut",
                    isEnabled: !selectedTopicIDs.isEmpty,
                    accentColor: .brandPrimaryRosePink,
                    action: onContinue
                )
                .padding(.horizontal, Spacing.md)
            }
            .padding(Spacing.md)
            .frame(maxWidth: .infinity)
            .glassEffect(
                .regular,
                in: RoundedRectangle(
                    cornerRadius: Radius.xl
                )
            )
            .padding(.horizontal, Spacing.md)
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var header: some View {
        VStack(
            alignment: .leading,
            spacing: Spacing.sm
        ) {
            Text(
                "Apa yang ingin kamu ketahui\ntentang satu sama lain?"
            )
            .font(AppFont.title3Bold)
            .foregroundStyle(Color.textPrimary)

            Text(
                "Pilihanmu akan jadi referensi topik pertanyaan untuk obrolan kalian nanti."
            )
            .font(AppFont.bodyRegular)
            .foregroundStyle(Color.textSecondary)
            .fixedSize(
                horizontal: false,
                vertical: true
            )
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
        let maximumWidth =
            proposal.width ?? .infinity

        var rowWidth: CGFloat = 0
        var rowHeight: CGFloat = 0
        var totalHeight: CGFloat = 0
        var contentWidth: CGFloat = 0

        for subview in subviews {
            let size =
                subview.sizeThatFits(.unspecified)

            let nextWidth =
                rowWidth == 0
                ? size.width
                : rowWidth + spacing + size.width

            if nextWidth > maximumWidth,
               rowWidth > 0 {
                contentWidth = max(
                    contentWidth,
                    rowWidth
                )

                totalHeight +=
                    rowHeight + spacing

                rowWidth = size.width
                rowHeight = size.height
            } else {
                rowWidth = nextWidth

                rowHeight = max(
                    rowHeight,
                    size.height
                )
            }
        }

        contentWidth = max(
            contentWidth,
            rowWidth
        )

        totalHeight += rowHeight

        return CGSize(
            width:
                proposal.width ?? contentWidth,
            height:
                totalHeight
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
            let size =
                subview.sizeThatFits(.unspecified)

            if x > bounds.minX,
               x + size.width > bounds.maxX {
                x = bounds.minX
                y += rowHeight + spacing
                rowHeight = 0
            }

            subview.place(
                at: CGPoint(
                    x: x,
                    y: y
                ),
                anchor: .topLeading,
                proposal: ProposedViewSize(
                    width: size.width,
                    height: size.height
                )
            )

            x += size.width + spacing

            rowHeight = max(
                rowHeight,
                size.height
            )
        }
    }
}

#Preview {
    @Previewable @State
    var selectedTopicIDs: Set<Int> = [
        2,
        7,
        19
    ]

    SelectedTopicsView(
        selectedTopicIDs: $selectedTopicIDs
    ) { }
}
