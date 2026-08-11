//
//  TurnBasedHatedChooseView.swift
//  DatingCard
//

import SwiftUI

struct TurnBasedHatedChooseView: View {
    let selectedTopicIDs: Set<Int>
    @Binding var hatedTopicIDs: Set<Int>

    let onSubmit: () -> Void

    private var availableTopics: [TopicModel] {
        Topics.all.filter { !selectedTopicIDs.contains($0.id) }
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.xl) {
                    header

                    TurnBasedTopicFlowLayout(spacing: Spacing.sm) {
                        ForEach(availableTopics) { topic in
                            TopicChip(
                                title: topic.name,
                                isSelected: hatedTopicIDs.contains(topic.id)
                            ) {
                                toggle(topic.id)
                            }
                        }
                    }
                }
                .padding(.horizontal, Spacing.xl)
                .padding(.top, Spacing.md)
                .padding(.bottom, Spacing.lg)
            }
            .scrollBounceBehavior(.basedOnSize)

            AppButton(title: "Mulai", action: onSubmit)
                .padding(.horizontal, Spacing.xl)
                .padding(.vertical, Spacing.lg)
        }
        .background(Color.bgPrimary.ignoresSafeArea())
        .onAppear(perform: removeSelectedTopicsFromHatedTopics)
        .onChange(of: selectedTopicIDs) {
            removeSelectedTopicsFromHatedTopics()
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Ada topik yang belum siap\nkamu bagikan?")
                .font(AppFont.title3Bold)
                .foregroundStyle(Color.textPrimary)

            Text("Topik yang kamu pilih tidak akan muncul dalam obrolan kalian.")
                .font(AppFont.bodyRegular)
                .foregroundStyle(Color.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
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
        hatedTopicIDs: .constant([7, 14]),
        onSubmit: { }
    )
}
