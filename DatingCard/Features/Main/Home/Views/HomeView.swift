//
//  HomeView.swift
//  DatingCard
//
//  Created by Arif Fathurrahman on 11/08/26.
//

import SwiftData
import SwiftUI

struct HomeView: View {
    private enum PendingRoute {
        case alternating
        case individual
    }

    @Query(
        filter: #Predicate<SessionModel> { session in
            session.isContinue == true
        },
        sort: \SessionModel.createdAt,
        order: .reverse
    ) private var unfinishedSessions: [SessionModel]

    @AppStorage("requestedMainTab") private var requestedMainTab = "home"

    @State private var isShowingTopicSelection = false
    @State private var isShowingPreviousSessionAlert = false
    @State private var pendingRoute: PendingRoute?
    @State private var isShowingAlternatingFlow = false
    @State private var isShowingIndividualFlow = false
    @State private var isPulsing = false

    var body: some View {
        ZStack {
            NavigationStack {
                GeometryReader { geometry in
                    ZStack(alignment: .topLeading) {
                        VStack(alignment: .leading, spacing: Spacing.md) {
                            Text("Kenal,\nLebih dari\nSekadar Nama")
                                .font(AppFont.largeTitleBold)
                                .foregroundStyle(Color.textPrimary)

                            Text(
                                "Mainkan kartu bersama,\nsaling bercerita, dan\nmengenal lebih dekat"
                            )
                            .font(AppFont.title3Regular)
                            .foregroundStyle(Color.textPrimary)
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.top, Spacing.xl)

                        startControl(
                            maximumDiameter: min(
                                geometry.size.width * 1.1,
                                430
                            )
                        )
                        .position(
                            x: geometry.size.width / 2,
                            y: geometry.size.height * 0.60
                        )
                    }
                }
                .ignoresSafeArea(.container, edges: .bottom)
                .background(homeBackground.ignoresSafeArea())
                .navigationDestination(isPresented: $isShowingAlternatingFlow) {
                    TurnBasedPreferencesView()
                        .toolbar(.hidden, for: .tabBar)
                }
                .navigationDestination(isPresented: $isShowingIndividualFlow) {
                    QRView()
                        .toolbar(.hidden, for: .tabBar)
                }
                .sheet(
                    isPresented: $isShowingTopicSelection,
                    onDismiss: presentPendingRoute
                ) {
                    TopicSelectionSheet(
                        onAlternatingSelected: {
                            pendingRoute = .alternating
                        },
                        onIndividualSelected: {
                            pendingRoute = .individual
                        }
                    )
                    .presentationDetents([.fraction(0.6)])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(Radius.xl)
                }
            }
            .allowsHitTesting(!isShowingPreviousSessionAlert)

            if isShowingPreviousSessionAlert {
                Color.textPrimary
                    .opacity(0.45)
                    .ignoresSafeArea()

                AppConfirmationAlert(
                    title: "Permainan Terakhir",
                    message: "Apakah kamu ingin melanjutkan permainan sebelumnya?",
                    accentColor: .accentDustyMauve,
                    confirmTitle: "Lanjutkan Bermain",
                    cancelTitle: "Tidak, Mulai Sesi Baru",
                    onConfirm: showHistory,
                    onCancel: startNewSession
                )
                .padding(.horizontal, Spacing.xl)
                .transition(
                    .scale(scale: 0.96)
                    .combined(with: .opacity)
                )
            }
        }
        .animation(
            .easeInOut(duration: 0.2),
            value: isShowingPreviousSessionAlert
        )
    }

    private func handleStartButton() {
        if unfinishedSessions.isEmpty {
            isShowingTopicSelection = true
        } else {
            isShowingPreviousSessionAlert = true
        }
    }

    private func showHistory() {
        isShowingPreviousSessionAlert = false
        requestedMainTab = "history"
    }

    private func startNewSession() {
        isShowingPreviousSessionAlert = false
        isShowingTopicSelection = true
    }

    private func presentPendingRoute() {
        guard let pendingRoute else { return }

        self.pendingRoute = nil

        switch pendingRoute {
        case .alternating:
            isShowingAlternatingFlow = true
        case .individual:
            isShowingIndividualFlow = true
        }
    }

    private func startControl(
        maximumDiameter: CGFloat
    ) -> some View {
        ZStack {
            TimelineView(.animation) { timeline in
                let time = timeline.date.timeIntervalSinceReferenceDate

                ZStack {
                    ForEach(0..<5, id: \.self) { index in
                        let ringDiameter = max(
                            0,
                            maximumDiameter - (CGFloat(index) * 72)
                        )

                        let wave = sin(
                            (time * 2.0) - (Double(index) * 0.9)
                        )

                        let normalizedWave = (wave + 1) / 2

                        let baseOpacity =
                            0.12 + (Double(index) * 0.07)

                        let animatedOpacity =
                            baseOpacity + (normalizedWave * 0.30)

                        Circle()
                            .stroke(
                                Color.bgCard.opacity(animatedOpacity),
                                style: StrokeStyle(
                                    lineWidth: 1.5,
                                    lineCap: .round,
                                    dash: [1, 8]
                                )
                            )
                            .frame(
                                width: ringDiameter,
                                height: ringDiameter
                            )
                    }
                }
            }

            Button {
                handleStartButton()
            } label: {
                Text("Mulai\nBermain")
                    .font(AppFont.title1Bold)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.accentDustyMauve)
                    .frame(width: 160, height: 160)
                    .background(Color.bgCard)
                    .clipShape(Circle())
                    .shadow(
                        color: Color.accentDustyMauve.opacity(0.35),
                        radius: 12,
                        y: 8
                    )
            }
            .buttonStyle(.plain)
            .accessibilityHint("Mulai sesi percakapan baru")
        }
        .frame(
            width: maximumDiameter,
            height: maximumDiameter
        )
    }

    private var homeBackground: some View {
        GeometryReader { geometry in
            ZStack {
                Color.bgPrimary

                Circle()
                    .fill(Color.accentDustyMauve)
                    .frame(width: 555, height: 555)
                    .blur(radius: 70)
                    .scaleEffect(isPulsing ? 1.08 : 0.94)
                    .opacity(isPulsing ? 0.95 : 0.72)
                    .position(
                        x: geometry.size.width / 2,
                        y: geometry.size.height * 0.6
                    )

                RadialGradient(
                    colors: [
                        Color.brandPrimaryRosePink.opacity(
                            isPulsing ? 0.68 : 0.42
                        ),
                        Color.brandPrimaryRosePink.opacity(0)
                    ],
                    center: .topTrailing,
                    startRadius: 0,
                    endRadius: 310
                )
                .scaleEffect(isPulsing ? 1.04 : 0.98)

                topRightOrbits
                    .position(
                        x: geometry.size.width,
                        y: 0
                    )
            }
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 1.3)
                    .repeatForever(
                        autoreverses: true
                    )
                ) {
                    isPulsing = true
                }
            }
        }
    }

    private var topRightOrbits: some View {
        ZStack {
            ForEach(0..<5, id: \.self) { index in
                let diameter = 280 - (CGFloat(index) * 44)

                Circle()
                    .stroke(
                        Color.accentDustyMauve.opacity(
                            0.32 - (Double(index) * 0.035)
                        ),
                        style: StrokeStyle(
                            lineWidth: 1.5,
                            lineCap: .round,
                            dash: [2, 9]
                        )
                    )
                    .frame(width: diameter, height: diameter)
            }
        }
        .frame(width: 280, height: 280)
        .accessibilityHidden(true)
    }
}

private struct TopicSelectionSheet: View {
    @Environment(\.dismiss) private var dismiss

    let onAlternatingSelected: () -> Void
    let onIndividualSelected: () -> Void

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                Text(
                    "Tentukan bagaimana kalian ingin memilih topik untuk mulai saling mengenal."
                )
                .font(AppFont.bodyRegular)
                .foregroundStyle(Color.textPrimary)

                VStack(alignment: .leading, spacing: Spacing.lg) {
                    explanation(
                        title: "Bergantian:",
                        description: "Pilih topik secara bergantian dari satu perangkat."
                    )

                    explanation(
                        title: "Masing-masing:",
                        description: "Pilih topik masing-masing dari perangkat kalian."
                    )
                }

                Spacer()

                VStack(spacing: Spacing.sm) {
                    AppButton(title: "Bergantian") {
                        onAlternatingSelected()
                        dismiss()
                    }

                    AppButton(
                        title: "Masing-masing",
                        variant: .secondary
                    ) {
                        onIndividualSelected()
                        dismiss()
                    }
                }
            }
            .padding(.horizontal, Spacing.xl)
            .navigationTitle("Pemilihan Topik Obrolan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
//                            .font(.system(size: 14, weight: .semibold))
//                            .foregroundStyle(Color.textPrimaryBlack)
//                            .frame(width: 32, height: 32)
//                            .background(Color.textSecondaryDarkGrey)
//                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Tutup")
                }
            }
        }
    }

    private func explanation(
        title: String,
        description: String
    ) -> some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(title)
                .font(AppFont.bodyBold)

            Text(description)
                .font(AppFont.bodyRegular)
        }
    }
}

#Preview {
    HomeView()
}
