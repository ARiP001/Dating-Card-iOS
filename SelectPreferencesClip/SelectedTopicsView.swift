//
//  SelectedTopicsView.swift
//  DatingCard
//
//  Created by Arif Fathurrahman on 10/08/26.
//

import SwiftUI

struct SelectedTopicsView: View {

    @Binding var selectedTopicIDs:
        Set<Int>

    let onContinue: () -> Void

    var body: some View {

        ScrollView {

            VStack(
                alignment: .leading,
                spacing: 24
            ) {

                header
                topicsSection
                continueButton
            }
            .padding()
        }

        .navigationTitle(
            "Preferences"
        )

        .navigationBarTitleDisplayMode(
            .inline
        )
    }

    // MARK: - Header

    private var header: some View {

        VStack(
            alignment: .leading,
            spacing: 8
        ) {

            Text(
                "What do you want to talk about?"
            )
            .font(.title2.bold())

            Text(
                "Choose topics that you would enjoy discussing."
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
    }

    // MARK: - Topics

    private var topicsSection: some View {

        VStack(spacing: 12) {

            ForEach(
                ConversationTopic.all
            ) { topic in

                TopicRow(
                    topic: topic,
                    isSelected:
                        selectedTopicIDs
                            .contains(topic.id)
                ) {

                    toggle(topic.id)
                }
            }
        }
    }

    // MARK: - Button

    private var continueButton:
        some View {

        Button {

            onContinue()

        } label: {

            Text("Continue")

                .fontWeight(.semibold)

                .frame(
                    maxWidth: .infinity
                )
        }

        .buttonStyle(
            .borderedProminent
        )

        .controlSize(.large)

        .disabled(
            selectedTopicIDs.isEmpty
        )
    }

    // MARK: - Action

    private func toggle(
        _ topicID: Int
    ) {

        if selectedTopicIDs
            .contains(topicID) {

            selectedTopicIDs
                .remove(topicID)

        } else {

            selectedTopicIDs
                .insert(topicID)
        }
    }
}
