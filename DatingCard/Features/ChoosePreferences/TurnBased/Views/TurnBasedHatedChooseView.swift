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

    private var availableTopics: [TopicModel] {
        Topics.all.filter {
            !selectedTopicIDs.contains($0.id)
        }
    }

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

                    TurnBasedTopicFlowLayout(
                        spacing: Spacing.sm
                    ) {
                        ForEach(availableTopics) { topic in
                            TopicChip(
                                title: topic.name,
                                isSelected: hatedTopicIDs.contains(topic.id),
                                accentColor: accentColor
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
                    title: "Mulai",
                    accentColor: accentColor,
                    action: onSubmit
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

    private func toggle(_ topicID: Int) {
        if hatedTopicIDs.contains(topicID) {
            hatedTopicIDs.remove(topicID)
        } else {
            hatedTopicIDs.insert(topicID)
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
