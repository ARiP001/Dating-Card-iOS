//
//  PreferencesSentView.swift
//  DatingCard
//
//  Created by Arif Fathurrahman on 10/08/26.
//

import SwiftUI

struct PreferencesSentView: View {
    private enum SendAnimationState {
        case envelopeOpen
        case envelopeClosed
        case paperPlane

        var symbolName: String {
            switch self {
            case .envelopeOpen:
                return "envelope.open.fill"

            case .envelopeClosed:
                return "envelope.fill"

            case .paperPlane:
                return "paperplane.fill"
            }
        }
    }

    @State private var isShowingSentContent = false

    @State private var sendAnimationState: SendAnimationState = .envelopeOpen

    @State private var symbolOpacity = 0.0
    @State private var symbolScale = 0.7

    @State private var planeOffset: CGSize = .zero
    @State private var planeRotation = 0.0

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
                sendAnimation
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .task {
            await playSendAnimation()
        }
    }

    private var sendAnimation: some View {
        ZStack {
            Circle()
                .fill(Color.brandPrimaryRosePink)
                .frame(width: 120, height: 120)
                .shadow(
                    color: Color.brandPrimaryRosePink.opacity(0.32),
                    radius: 20,
                    y: 10
                )

            Image(systemName: sendAnimationState.symbolName)
                .font(.system(size: 48, weight: .semibold))
                .foregroundStyle(Color.bgCard)
                .contentTransition(
                    .symbolEffect(.replace)
                )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .opacity(symbolOpacity)
        .scaleEffect(symbolScale)
        .offset(planeOffset)
        .rotationEffect(.degrees(planeRotation))
        .accessibilityLabel("Preferensi sedang dikirim")
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

    private func playSendAnimation() async {
        // 1. Envelope open appears
        withAnimation(
            .spring(response: 0.45, dampingFraction: 0.72)
        ) {
            symbolOpacity = 1
            symbolScale = 1
        }

        try? await Task.sleep(nanoseconds: 650_000_000)
        guard !Task.isCancelled else { return }

        // 2. Envelope closes
        withAnimation(.easeInOut(duration: 0.35)) {
            sendAnimationState = .envelopeClosed
        }

        try? await Task.sleep(nanoseconds: 500_000_000)
        guard !Task.isCancelled else { return }

        // 3. Envelope becomes paper plane
        withAnimation(.easeInOut(duration: 0.35)) {
            sendAnimationState = .paperPlane
            symbolScale = 0.92
        }

        try? await Task.sleep(nanoseconds: 350_000_000)
        guard !Task.isCancelled else { return }

        // 4. Paper plane flies away
        withAnimation(.easeIn(duration: 0.55)) {
            planeOffset = CGSize(
                width: 180,
                height: -180
            )

            planeRotation = 10
            symbolScale = 0.55
            symbolOpacity = 0
        }

        try? await Task.sleep(nanoseconds: 550_000_000)
        guard !Task.isCancelled else { return }

        // 5. Show success content
        withAnimation(.easeOut(duration: 0.45)) {
            isShowingSentContent = true
        }
    }
}

#Preview {
    PreferencesSentView()
}
