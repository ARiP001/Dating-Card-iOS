//
//  AppLoadingView.swift
//  DatingCard
//

import SwiftUI

struct AppLoadingView: View {
    let message: String

    var body: some View {
        VStack(spacing: Spacing.md) {
            ProgressView()
                .tint(Color.accentPrimary)

            Text(message)
                .font(AppFont.caption1Regular)
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(Spacing.lg)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    AppLoadingView(message: "Menunggu perangkat lain menyelesaikan pilihannya")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bgPrimary)
}

struct SessionWaitingView: View {
    let message: String

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.bgCard
                    .ignoresSafeArea()

                BottomRingDecoration()

                VStack(spacing: Spacing.md) {
                    Spacer(minLength: geometry.size.height * 0.38)

                    ProgressView()
                        .tint(Color.textPrimary)
                        .scaleEffect(1.15)

                    Text(message)
                        .font(AppFont.bodyBold)
                        .foregroundStyle(Color.textPrimary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, Spacing.xl)
                .padding(.bottom, Spacing.xl)
            }
        }
    }
}

struct SessionInstructionView: View {
    let message: String
    let buttonTitle: String
    let onStart: () -> Void

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.bgCard
                    .ignoresSafeArea()

                BottomRingDecoration(
                    strokeColor: Color.border,
                    baseOpacity: 0.22,
                    scaleFactor: 1.34,
                    offsetY: 170
                )

                VStack(spacing: Spacing.lg) {
                    Spacer(minLength: geometry.size.height * 0.54)

                    ProgressView()
                        .tint(Color.textPrimary)
                        .scaleEffect(1.15)

                    Text(message)
                        .font(AppFont.bodyBold)
                        .foregroundStyle(Color.textPrimary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer(minLength: 0)

                    AppButton(title: buttonTitle, action: onStart)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, Spacing.xl)
                .padding(.bottom, Spacing.xl)
            }
        }
    }
}

private struct BottomRingDecoration: View {
    let strokeColor: Color
    let baseOpacity: Double
    let scaleFactor: CGFloat
    let offsetY: CGFloat

    init(
        strokeColor: Color = .border,
        baseOpacity: Double = 0.45,
        scaleFactor: CGFloat = 1.26,
        offsetY: CGFloat = 190
    ) {
        self.strokeColor = strokeColor
        self.baseOpacity = baseOpacity
        self.scaleFactor = scaleFactor
        self.offsetY = offsetY
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<4, id: \.self) { index in
                    Circle()
                        .stroke(
                            strokeColor.opacity(baseOpacity - (Double(index) * 0.08)),
                            style: StrokeStyle(
                                lineWidth: 1.4,
                                lineCap: .round,
                                dash: [1, 7]
                            )
                        )
                        .frame(
                            width: min(geometry.size.width * scaleFactor, 430) - (CGFloat(index) * 46),
                            height: min(geometry.size.width * scaleFactor, 430) - (CGFloat(index) * 46)
                        )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .offset(y: min(geometry.size.height * 0.32, offsetY))
            .allowsHitTesting(false)
        }
        .ignoresSafeArea()
    }
}
