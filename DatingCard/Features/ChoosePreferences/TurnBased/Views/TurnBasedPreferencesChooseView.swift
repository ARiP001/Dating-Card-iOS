//
//  TurnBasedPreferencesChooseView.swift
//  DatingCard
//

import SwiftUI

struct TurnBasedPreferencesChooseView: View {
    @Binding var selectedTopicIDs: Set<Int>
    let accentColor: Color

    let onContinue: () -> Void

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
                            BigTopic(
                                title: group.name,
                                topics: group.topics,
                                selectedTopicIDs: $selectedTopicIDs,
                                accentColor: accentColor
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
        .safeAreaInset(edge: .bottom, spacing: 0) {
            AppButton(
                title: "Lanjut",
                variant: selectedTopicIDs.isEmpty
                    ? .secondary
                    : .primary,
                isEnabled: !selectedTopicIDs.isEmpty,
                accentColor: accentColor,
                showsBorder: false,
                disabledOpacity: 1,
                action: onContinue
            )
            .padding(.horizontal, Spacing.xl)
            .padding(.top, Spacing.md)
            .padding(.bottom, Spacing.sm)
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
        }
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
    TurnBasedPreferencesChooseView(
        selectedTopicIDs: .constant([2, 7, 19]),
        accentColor: .accentDustyMauve,
        onContinue: { }
    )
}
