//
//  TurnBasedHatedChooseView.swift
//  DatingCard
//
//
//  TurnBasedHatedChooseView.swift
//  DatingCard
//

import SwiftUI

struct TurnBasedHatedChooseView: View {
    let selectedTopicIDs: Set<Int>
    let accentColor: Color

    @Binding var hatedTopicIDs: Set<Int>

    let onSubmit: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.bgPrimary
                .ignoresSafeArea()

            Circle()
                .fill(
                    accentColor.opacity(0.25)
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

                    VStack(spacing: Spacing.sm) {
                        ForEach(Topics.groups) { group in
                            let topics = group.topics.filter {
                                !selectedTopicIDs.contains($0.id)
                            }

                            if !topics.isEmpty {
                                BigTopic(
                                    title: group.name,
                                    topics: topics,
                                    selectedTopicIDs: $hatedTopicIDs,
                                    accentColor: accentColor
                                )
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
        .safeAreaInset(edge: .bottom, spacing: 0) {
            AppButton(
                title: "Mulai",
                accentColor: accentColor,
                action: onSubmit
            )
            .padding(.horizontal, Spacing.xl)
            .padding(.top, Spacing.md)
            .padding(.bottom, Spacing.sm)
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
        }
        .onAppear(
            perform: removeSelectedTopicsFromHatedTopics
        )
        .onChange(of: selectedTopicIDs) {
            removeSelectedTopicsFromHatedTopics()
        }
    }

    private var header: some View {
        VStack(
            alignment: .leading,
            spacing: Spacing.sm
        ) {
            Text(
                "Ada topik yang belum siap\nkamu bagikan?"
            )
            .font(AppFont.title3Bold)
            .foregroundStyle(Color.textPrimary)

            Text(
                "Topik yang kamu pilih tidak akan muncul dalam obrolan kalian."
            )
            .font(AppFont.bodyRegular)
            .foregroundStyle(Color.textSecondary)
            .fixedSize(
                horizontal: false,
                vertical: true
            )
        }
    }

    private func removeSelectedTopicsFromHatedTopics() {
        hatedTopicIDs.subtract(selectedTopicIDs)
    }
}

#Preview {
    TurnBasedHatedChooseView(
        selectedTopicIDs: [1, 2, 6],
        accentColor: .accentDustyMauve,
        hatedTopicIDs: .constant([7, 14]),
        onSubmit: { }
    )
}
