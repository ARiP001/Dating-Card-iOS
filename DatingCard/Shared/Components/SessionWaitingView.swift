//
//  SessionWaitingView.swift
//  DatingCard
//

import SwiftUI

struct SessionWaitingView: View {
    let message: String

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                waitingBackground

                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: geometry.size.height * 0.42)

                    ProgressView()
                        .tint(Color.accentDustyMauve)
                        .scaleEffect(2)

                    Spacer()

                    Text(message)
                        .font(AppFont.title1Bold)
                        .foregroundStyle(Color.bgCard)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, geometry.size.height * 0.14)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, Spacing.xl)
            }
        }
    }

    private var waitingBackground: some View {
        ZStack {
            LinearGradient(
                stops: [
                    .init(color: Color.bgPrimary, location: 0),
                    .init(color: Color.bgPrimary, location: 0.34),
                    .init(
                        color: Color.accentDustyMauve.opacity(0.12),
                        location: 0.47
                    ),
                    .init(
                        color: Color.accentDustyMauve.opacity(0.72),
                        location: 0.7
                    ),
                    .init(color: Color.accentDustyMauve, location: 0.86),
                    .init(color: Color.accentDustyMauve, location: 1)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            BottomWaitingOrbits()
        }
    }
}

private struct BottomWaitingOrbits: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<5, id: \.self) { index in
                    let opacity = max(
                        0.08,
                        0.24 - (Double(index) * 0.03)
                    )
                    let diameter = max(
                        0,
                        720 - (CGFloat(index) * 72)
                    )

                    Circle()
                        .stroke(
                            Color.bgCard.opacity(opacity),
                            style: StrokeStyle(
                                lineWidth: 1.6,
                                lineCap: .round,
                                dash: [2, 10]
                            )
                        )
                        .frame(width: diameter, height: diameter)
                }
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .bottom
            )
            .offset(y: 300)
            .allowsHitTesting(false)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SessionWaitingView(
        message: "Menunggu\nperangkat lain\nmenyelesaikan\npilihannya..."
    )
}
