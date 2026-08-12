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

                    VStack(spacing: Spacing.sm) {
                        ForEach(Topics.groups) { group in
                            BigTopic(
                                title: group.name,
                                topics: group.topics,
                                selectedTopicIDs: $selectedTopicIDs,
                                accentColor: .brandPrimaryRosePink
                            )
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
