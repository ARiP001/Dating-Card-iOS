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
        VStack(alignment: .leading, spacing: 0) {
            Image("cardStackOnboarding")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .frame(maxHeight: 360)
                .accessibilityHidden(true)

            Spacer()

            VStack(alignment: .leading, spacing: Spacing.lg) {
                Text("Satu Kartu.\nSatu Cerita.")
                    .font(AppFont.title2Bold)
                    .foregroundStyle(Color.textPrimary)

                Text(
                    "Setiap kartu menghadirkan kesempatan untuk mengenal seseorang lebih dalam dengan cara yang berbeda."
                )
                .font(AppFont.bodyRegular)
                .foregroundStyle(Color.textSecondary)
            }

            Spacer()

            AppButton(
                title: "Lanjut",
                action: onContinue
            )
        }
        .padding(.horizontal, Spacing.xl)
        .padding(.vertical, Spacing.lg)
        .background(Color.bgPrimary.ignoresSafeArea())
    }
}
