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
        VStack(alignment: .center, spacing: 0) {
            Image("cardStackOnboarding")
                .resizable()
                .scaledToFit()
                .frame(width: 288, height: 325)
                .accessibilityHidden(true)
                .padding(.top, Spacing.xxl)

            Spacer()

            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text("Satu Kartu.\nSatu Cerita.")
                    .font(AppFont.largeTitleBold)
                    .foregroundStyle(Color.textPrimary)

                Text(
                    "Setiap kartu menghadirkan kesempatan untuk mengenal seseorang lebih dalam dengan cara yang berbeda."
                )
                .font(AppFont.bodyBold)
                .foregroundStyle(Color.textSecondary)
            }

            Spacer()

            AppButton(
                title: "Ayo Mulai",
                action: onContinue
            )
        }
        .padding(.horizontal, Spacing.xl)
        .padding(.vertical, Spacing.lg)
        .background(onboardingBackground.ignoresSafeArea())
    }

    private var onboardingBackground: some View {
        ZStack {
            Color.bgPrimary

            LinearGradient(
                colors: [
                    Color.accentDustyMauve,
                    Color.brandPrimaryRosePink
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            .mask {
                LinearGradient(
                    stops: [
                        .init(color: .black, location: 0),
                        .init(color: .black.opacity(0.9), location: 0.28),
                        .init(color: .clear, location: 0.7)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
        }
    }
}
