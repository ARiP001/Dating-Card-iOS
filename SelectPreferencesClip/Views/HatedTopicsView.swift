//
//  HatedTopicsView.swift
//  SelectPreferencesClip
//

import SwiftUI

struct HatedTopicsView: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var selectedTopicIDs: Set<Int>
    @Binding var hatedTopicIDs: Set<Int>

    let isSubmitting: Bool
    let onSubmit: () -> Void

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
                    backButton

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
                                    accentColor: .brandPrimaryRosePink
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
        .overlay(alignment: .bottom) {
            VStack {
                AppButton(
                    title: isSubmitting
                        ? "Mengirim..."
                        : "Mulai",
                    isEnabled: !isSubmitting,
                    accentColor: .brandPrimaryRosePink,
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
        .toolbar(.hidden, for: .navigationBar)
        .onAppear(
            perform: removeSelectedTopicsFromHatedTopics
        )
        .onChange(of: selectedTopicIDs) {
            removeSelectedTopicsFromHatedTopics()
        }
    }

    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .font(AppFont.headlineSemibold)
                .foregroundStyle(Color.bgCard)
                .frame(
                    width: 44,
                    height: 44
                )
                .background(
                    Color.brandPrimaryRosePink
                )
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Kembali")
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
    NavigationStack {
        HatedTopicsView(
            selectedTopicIDs: .constant([1, 2, 7]),
            hatedTopicIDs: .constant([19, 23]),
            isSubmitting: false
        ) { }
    }
}
