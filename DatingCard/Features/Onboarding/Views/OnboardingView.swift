//
//  OnboardingView.swift
//  DatingCard
//
//  Created by Arif Fathurrahman on 11/08/26.
//

import SwiftUI

struct OnboardingView: View {
    let onContinue: () -> Void

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Image("cardStackOnboarding")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .frame(
                            height: min(
                                geometry.size.height * 0.44,
                                360
                            )
                        )
                        .accessibilityHidden(true)

                    Spacer(minLength: Spacing.lg)

                    VStack(alignment: .leading, spacing: Spacing.lg) {
                        Text("Satu Kartu.\nSatu Cerita.")
                            .font(AppFont.title2Bold)
                            .foregroundStyle(Color.textPrimary)

                        Text(
                            "Setiap kartu menghadirkan kesempatan untuk mengenal seseorang lebih dalam dengan cara yang berbeda."
                        )
                        .font(AppFont.bodyRegular)
                        .foregroundStyle(Color.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                    }

                    Spacer(minLength: Spacing.xl)

                    AppButton(
                        title: "Lanjut",
                        action: onContinue
                    )
                }
                .frame(
                    minHeight: geometry.size.height - (Spacing.lg * 2)
                )
                .padding(.horizontal, Spacing.xl)
                .padding(.vertical, Spacing.lg)
            }
            .scrollBounceBehavior(.basedOnSize)
        }
        .background(Color.bgPrimary.ignoresSafeArea())
    }
}

#Preview {
    OnboardingView(onContinue: {})
}
