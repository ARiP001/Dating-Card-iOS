//
//  PreferencesSentView.swift
//  DatingCard
//
//  Created by Arif Fathurrahman on 10/08/26.
//

import SwiftUI

struct PreferencesSentView: View {
    @State private var isShowingSentContent = false
    @State private var checkmarkOpacity = 0.0
    @State private var checkmarkScale = 0.45
    @State private var checkmarkRotation = -12.0

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.bgPrimary
                .ignoresSafeArea()

            Circle()
                .fill(Color.brandPrimaryRosePink.opacity(0.25))
                .frame(width: 360, height: 360)
                .blur(radius: 80)
                .offset(x: 120, y: -120)
                .allowsHitTesting(false)
                .accessibilityHidden(true)

            if isShowingSentContent {
                sentOrbits

                sentContent
                    .transition(
                        .opacity.combined(
                            with: .scale(scale: 0.96)
                        )
                    )
            } else {
                animatedCheckmark
                    .opacity(checkmarkOpacity)
                    .scaleEffect(checkmarkScale)
                    .rotationEffect(.degrees(checkmarkRotation))
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .task {
            await playConfirmationAnimation()
        }
    }

    private var animatedCheckmark: some View {
        ZStack {
            Circle()
                .fill(Color.brandPrimaryRosePink)
                .frame(width: 120, height: 120)
                .shadow(
                    color: Color.brandPrimaryRosePink.opacity(0.32),
                    radius: 20,
                    y: 10
                )

            Image(systemName: "checkmark")
                .font(.system(size: 50, weight: .bold))
                .foregroundStyle(Color.bgCard)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityLabel("Preferensi berhasil dikirim")
    }

    private var sentContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer()

            VStack(alignment: .leading, spacing: Spacing.md) {
                Text("Preferensi Terkirim")
                    .font(AppFont.largeTitleBold)
                    .foregroundStyle(Color.textPrimary)

                Text(
                    "Pilihanmu sudah berhasil dikirim ke perangkat utama."
                )
                .font(AppFont.title3Regular)
                .foregroundStyle(Color.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()

            Text(
                "Kamu sekarang bisa menutup App Clip ini dan melanjutkan permainan di perangkat utama."
            )
            .font(AppFont.bodyRegular)
            .foregroundStyle(Color.textSecondary)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.bottom, Spacing.xl)
        }
        .padding(.horizontal, Spacing.xl)
        .accessibilityElement(children: .combine)
    }

    private var sentOrbits: some View {
        ZStack {
            ForEach(0..<5, id: \.self) { index in
                let diameter = 420 - (CGFloat(index) * 54)

                Circle()
                    .stroke(
                        Color.brandPrimaryRosePink.opacity(
                            0.16 - (Double(index) * 0.02)
                        ),
                        style: StrokeStyle(
                            lineWidth: 1.5,
                            lineCap: .round,
                            dash: [2, 10]
                        )
                    )
                    .frame(width: diameter, height: diameter)
            }
        }
        .offset(x: 150, y: 500)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    private func playConfirmationAnimation() async {
        withAnimation(
            .spring(response: 0.5, dampingFraction: 0.68)
        ) {
            checkmarkOpacity = 1
            checkmarkScale = 1
            checkmarkRotation = 0
        }

        try? await Task.sleep(nanoseconds: 1_150_000_000)
        guard !Task.isCancelled else { return }

        withAnimation(.easeIn(duration: 0.28)) {
            checkmarkOpacity = 0
            checkmarkScale = 1.12
        }

        try? await Task.sleep(nanoseconds: 300_000_000)
        guard !Task.isCancelled else { return }

        withAnimation(.easeOut(duration: 0.45)) {
            isShowingSentContent = true
        }
    }
}

#Preview {
    PreferencesSentView()
}
