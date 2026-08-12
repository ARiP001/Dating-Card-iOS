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
        ZStack {
            LinearGradient(
                stops: [
                    .init(color: .bgPrimary, location: 0),
                    .init(color: .bgPrimary, location: 0.38),
                    .init(
                        color: .brandPrimaryRosePink.opacity(0.42),
                        location: 0.68
                    ),
                    .init(
                        color: .brandPrimaryRosePink,
                        location: 1
                    )
                ],
                startPoint: .top,
                endPoint: .bottom
            )
                .ignoresSafeArea()

            ConcentricDashedCirclesView(
                yOffset: 30,
                strokeColor: Color.bgCard.opacity(0.18),
                dashPattern: [2, 9]
            )
            .allowsHitTesting(false)
            .accessibilityHidden(true)

            if isShowingSentContent {
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
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: Spacing.xl) {
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        Text("Topik Pilihanmu Sudah Terkirim")
                            .font(AppFont.title1Bold)
                            .foregroundStyle(Color.textPrimary)

//                        Text(
//                            "Topik pilihanmu sudah berhasil dikirim ke perangkat utama."
//                        )
//                        .font(AppFont.bodyRegular)
//                        .foregroundStyle(Color.textPrimary)
//                        .fixedSize(horizontal: false, vertical: true)
                    }

                    Text(
                        "Kamu sekarang bisa menutup App Clip ini dan melanjutkan permainan di perangkat utama."
                    )
                    .font(AppFont.bodyRegular)
                    .foregroundStyle(Color.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()
//
//                Button { } label: {
//                    Text("Close")
//                        .font(AppFont.headlineSemibold)
//                        .foregroundStyle(Color.brandPrimaryRosePink)
//                        .frame(maxWidth: .infinity)
//                        .frame(height: 56)
//                        .background(Color.bgCard)
//                        .clipShape(Capsule())
//                        .shadow(
//                            color: Color.textPrimary.opacity(0.1),
//                            radius: 8,
//                            y: 4
//                        )
//                }
//                .buttonStyle(.plain)
//                .accessibilityHint(
//                    "Tutup App Clip dari app switcher untuk kembali ke perangkat utama"
//                )
            }
            .padding(.horizontal, Spacing.xl)
            .padding(
                .top,
                max(Spacing.xxl, geometry.size.height * 0.20)
            )
            .padding(.bottom, Spacing.lg)
        }
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
