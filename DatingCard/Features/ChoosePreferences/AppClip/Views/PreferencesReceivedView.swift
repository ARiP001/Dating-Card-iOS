//
//  PreferencesReceivedView.swift
//  DatingCard
//

import SwiftUI

struct PreferencesReceivedView: View {
    private enum ReceiveState: Equatable {
        case paperPlane
        case envelopeClosed
        case envelopeOpen

        var symbolName: String {
            switch self {
            case .paperPlane:
                return "paperplane.fill"
            case .envelopeClosed:
                return "envelope.fill"
            case .envelopeOpen:
                return "envelope.open.fill"
            }
        }
    }

    let onAnimationCompleted: () -> Void

    @State private var receiveState: ReceiveState = .paperPlane
    @State private var symbolOffset = CGSize(width: -220, height: 220)
    @State private var symbolOpacity = 0.0
    @State private var symbolScale = 0.6
    @State private var symbolRotation = -18.0
    @State private var hasStartedAnimation = false

    var body: some View {
        ZStack {
            Color.accentDustyMauve
                .ignoresSafeArea()

            VStack(spacing: Spacing.xl) {
                receiveAnimation

                Text("Preferensi diterima")
                    .font(AppFont.title1Bold)
                    .foregroundStyle(Color.bgCard)
                    .opacity(receiveState == .envelopeOpen ? 1 : 0)
                    .offset(y: receiveState == .envelopeOpen ? 0 : 8)
                    .animation(
                        .easeOut(duration: 0.3),
                        value: receiveState
                    )
            }
        }
        .task {
            guard !hasStartedAnimation else {
                return
            }

            hasStartedAnimation = true
            await playReceiveAnimation()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Preferensi pasangan diterima")
        .toolbar(.hidden, for: .navigationBar)
    }

    private var receiveAnimation: some View {
        ZStack {
            Circle()
                .fill(Color.bgCard.opacity(0.14))
                .frame(width: 120, height: 120)

            Image(systemName: receiveState.symbolName)
                .font(.system(size: 48, weight: .semibold))
                .foregroundStyle(Color.bgCard)
                .contentTransition(
                    .symbolEffect(.replace)
                )
                .offset(symbolOffset)
                .scaleEffect(symbolScale)
                .rotationEffect(.degrees(symbolRotation))
                .opacity(symbolOpacity)
        }
        .frame(width: 120, height: 120)
    }

    @MainActor
    private func playReceiveAnimation() async {
        withAnimation(
            .spring(
                response: 0.6,
                dampingFraction: 0.78
            )
        ) {
            symbolOffset = .zero
            symbolOpacity = 1
            symbolScale = 1
            symbolRotation = 0
        }

        try? await Task.sleep(
            nanoseconds: 700_000_000
        )
        guard !Task.isCancelled else { return }

        withAnimation(
            .easeInOut(duration: 0.35)
        ) {
            receiveState = .envelopeClosed
        }

        try? await Task.sleep(
            nanoseconds: 500_000_000
        )
        guard !Task.isCancelled else { return }

        withAnimation(
            .easeInOut(duration: 0.4)
        ) {
            receiveState = .envelopeOpen
            symbolScale = 1.08
        }

        try? await Task.sleep(
            nanoseconds: 700_000_000
        )
        guard !Task.isCancelled else { return }

        onAnimationCompleted()
    }
}

#Preview {
    PreferencesReceivedView { }
}
