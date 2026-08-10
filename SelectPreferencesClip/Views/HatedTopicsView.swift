//
//  HatedTopicsView.swift
//  DatingCard
//
//  Created by Arif Fathurrahman on 10/08/26.
//

import SwiftUI

struct HatedTopicsView: View {

    @Binding var selectedTopicIDs: Set<Int>

    @Binding var hatedTopicIDs:Set<Int>

    let isSubmitting: Bool
    let onSubmit: () -> Void

    private var availableTopics: [ConversationTopic] {
        ConversationTopic.all.filter {
            !selectedTopicIDs.contains($0.id)
        }
    }
    
    var body: some View {

        ScrollView {

            VStack(
                alignment: .leading,
                spacing: 24
            ) {

                header

                topicsSection

                submitButton
            }
            .padding()
        }

        .navigationTitle(
            "Boundaries"
        )

        .navigationBarTitleDisplayMode(
            .inline
        )

        .onAppear {
            removeSelectedTopicsFromHatedTopics()
        }

        .onChange(of: selectedTopicIDs) {
            removeSelectedTopicsFromHatedTopics()
        }
    }

    // MARK: - Header

    private var header: some View {

        VStack(
            alignment: .leading,
            spacing: 8
        ) {

            Text(
                "Anything you'd rather not discuss?"
            )
            .font(.title2.bold())

            Text(
                "Choose topics that you don't feel comfortable sharing."
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)

            Text(
                "You can leave this empty."
            )
            .font(.caption)
            .foregroundStyle(.secondary)
        }
    }

    // MARK: - Topics
    private var topicsSection: some View {
        VStack(spacing: 12) {

            ForEach(
                availableTopics
            ) { topic in

                TopicRow(
                    topic: topic,
                    isSelected:
                        hatedTopicIDs.contains(
                            topic.id
                        ),
                    style: .negative
                ) {
                    toggle(topic.id)
                }
            }
        }
    }

    // MARK: - Submit

    private var submitButton:
        some View {

        Button {

            onSubmit()

        } label: {

            HStack(spacing: 10) {

                if isSubmitting {

                    ProgressView()
                        .tint(.white)

                } else {

                    Image(
                        systemName:
                            "paperplane.fill"
                    )
                }

                Text(
                    isSubmitting
                    ? "Sending..."
                    : "Send Preferences"
                )
                .fontWeight(.semibold)
            }

            .frame(
                maxWidth: .infinity
            )
        }

        .buttonStyle(
            .borderedProminent
        )

        .controlSize(.large)

        .disabled(isSubmitting)
    }

    // MARK: - Action

    private func toggle(
        _ topicID: Int
    ) {

        if hatedTopicIDs
            .contains(topicID) {

            hatedTopicIDs
                .remove(topicID)

        } else {

            hatedTopicIDs
                .insert(topicID)
        }
    }

    private func removeSelectedTopicsFromHatedTopics() {
        hatedTopicIDs.subtract(selectedTopicIDs)
    }
}
