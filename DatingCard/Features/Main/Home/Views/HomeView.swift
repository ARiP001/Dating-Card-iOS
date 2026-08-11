//
//  HomeView.swift
//  DatingCard
//
//  Created by Arif Fathurrahman on 11/08/26.
//

import SwiftUI

struct HomeView: View {
    private enum PendingRoute {
        case alternating
        case individual
    }

    @State private var isShowingTopicSelection = false
    @State private var pendingRoute: PendingRoute?
    @State private var isShowingAlternatingFlow = false
    @State private var isShowingIndividualFlow = false

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack(alignment: .topLeading) {
                    VStack(alignment: .leading, spacing: Spacing.md) {
                        Text("Kenal Lebih\ndari Sekadar\nNama")
                            .font(AppFont.largeTitleBold)
                            .foregroundStyle(Color.textPrimary)

                        Text(
                            "Mainkan kartu bersama,\nsaling bercerita, dan\nmengenal lebih dekat"
                        )
                        .font(AppFont.title3Regular)
                        .foregroundStyle(Color.textSecondary)
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
            .background(Color.bgPrimary.ignoresSafeArea())
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
                .presentationDetents([.fraction(0.64)])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(Radius.xl)
                .presentationBackground(Color.bgPrimary)
            }
        }
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
            ForEach(0..<7, id: \.self) { index in
                Circle()
                    .stroke(
                        Color.border.opacity(
                            0.55 - (Double(index) * 0.06)
                        ),
                        style: StrokeStyle(
                            lineWidth: 1.5,
                            lineCap: .round,
                            dash: [1, 7]
                        )
                    )
                    .frame(
                        width: maximumDiameter - (CGFloat(index) * 42),
                        height: maximumDiameter - (CGFloat(index) * 42)
                    )
            }

            Button {
                isShowingTopicSelection = true
            } label: {
                Text("MULAI")
                    .font(AppFont.title3Bold)
                    .foregroundStyle(Color.bgCard)
                    .frame(width: 148, height: 148)
                    .background(Color.accentPrimary)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .accessibilityHint("Mulai sesi percakapan baru")
        }
        .frame(width: maximumDiameter, height: maximumDiameter)
    }
}

private struct TopicSelectionSheet: View {
    @Environment(\.dismiss) private var dismiss

    let onAlternatingSelected: () -> Void
    let onIndividualSelected: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            header

            Text(
                "Tentukan bagaimana kalian ingin memilih topik untuk mulai saling mengenal."
            )
            .font(AppFont.bodyRegular)
            .foregroundStyle(Color.textPrimary)
            .fixedSize(horizontal: false, vertical: true)

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

            Spacer(minLength: Spacing.sm)

            VStack(spacing: Spacing.sm) {
                AppButton(title: "Bergantian") {
                    onAlternatingSelected()
                    dismiss()
                }

                AppButton(title: "Masing-masing", variant: .secondary) {
                    onIndividualSelected()
                    dismiss()
                }
            }
        }
        .padding(.horizontal, Spacing.xl)
        .padding(.top, Spacing.md)
        .padding(.bottom, Spacing.lg)
        .background(Color.bgPrimary)
    }

    private var header: some View {
        ZStack {
            Text("Pemilihan Topik")
                .font(AppFont.title3Bold)
                .foregroundStyle(Color.textPrimary)
                .frame(maxWidth: .infinity)

            HStack {
                Spacer()

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2.weight(.medium))
                        .foregroundStyle(Color.textPrimary)
                        .frame(width: 44, height: 44)
                        .background(Color.surfaceSecondary)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Tutup")
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
                .foregroundStyle(Color.textPrimary)

            Text(description)
                .font(AppFont.bodyRegular)
                .foregroundStyle(Color.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    HomeView()
}
