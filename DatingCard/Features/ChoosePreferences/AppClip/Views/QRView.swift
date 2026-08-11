//
//  QRView.swift
//  DatingCard
//

import SwiftUI

struct QRView: View {
    private enum FlowStep: Equatable {
        case preferences
        case waitingForPartner
    }

    @StateObject private var viewModel = FullAppViewModel()

    @State private var selectedTopicIDs: Set<Int> = []
    @State private var hatedTopicIDs: Set<Int> = []
    @State private var flowStep: FlowStep = .preferences
    @State private var isShowingHatedTopics = false
    @State private var hasPrintedCombinedPreferences = false

    var onPreferencesCompleted: (Set<Int>, Set<Int>) -> Void = { _, _ in }

    var body: some View {
        Group {
            if shouldShowCompletedContent {
                completedContent
                    .transition(.opacity)
            } else if partnerHasJoined {
                preferencesContent
                    .transition(.opacity)
            } else {
                qrContent
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: partnerHasJoined)
        .animation(
            .easeInOut(duration: 0.25),
            value: shouldShowCompletedContent
        )
        .background(Color.bgPrimary.ignoresSafeArea())
        .task {
            if viewModel.sessionID == nil {
                await viewModel.createNewSession()
            }
        }
        .onChange(of: viewModel.state) {
            printCombinedPreferencesIfNeeded()
        }
        .onChange(of: flowStep) {
            printCombinedPreferencesIfNeeded()
        }
        .navigationDestination(isPresented: $isShowingHatedTopics) {
            QRHatedChooseView(
                selectedTopicIDs: selectedTopicIDs,
                hatedTopicIDs: $hatedTopicIDs,
                onSubmit: showWaitingState
            )
        }
    }

    private var partnerHasJoined: Bool {
        switch viewModel.state {
        case .joined, .completed:
            return true
        default:
            return false
        }
    }

    private var hostHasCompletedPreferences: Bool {
        flowStep == .waitingForPartner
    }

    private var shouldShowCompletedContent: Bool {
        viewModel.state == .completed && hostHasCompletedPreferences
    }

    @ViewBuilder
    private var preferencesContent: some View {
        switch flowStep {
        case .preferences:
            QRPreferencesChooseView(
                selectedTopicIDs: $selectedTopicIDs,
                onContinue: {
                    hatedTopicIDs.subtract(selectedTopicIDs)
                    isShowingHatedTopics = true
                }
            )

        case .waitingForPartner:
            SessionWaitingView(
                message: "Menunggu perangkat lain\nmenyelesaikan pilihannya"
            )
        }
    }

    @ViewBuilder
    private var completedContent: some View {
        SessionInstructionView(
            message: "Letakkan HP di tempat yang\ndapat kalian berdua lihat bersama",
            buttonTitle: "Mulai"
        ) {
            onPreferencesCompleted(
                selectedTopicIDs,
                hatedTopicIDs
            )
        }
    }

    private var qrContent: some View {
        VStack(spacing: Spacing.xl) {
//            Spacer()

            VStack(spacing: Spacing.sm) {
                Text("Pindai Kode QR\nuntuk Bermain Bersama")
                    .font(AppFont.title2Bold)
                    .foregroundStyle(Color.textPrimary)
                    .multilineTextAlignment(.center)

                Text(
                    "Mulai dengan memilih topik yang ingin kalian jelajahi bersama."
                )
                .font(AppFont.bodyRegular)
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            }

            stateContent

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, Spacing.xl)
    }

    @ViewBuilder
    private var stateContent: some View {
        switch viewModel.state {
        case .idle, .creating:
            AppLoadingView(message: "Menyiapkan sesi...")
                .frame(height: 300)

        case .waiting:
            qrCode

        case let .failed(message):
            VStack(spacing: Spacing.md) {
                Text(message)
                    .font(AppFont.bodyRegular)
                    .foregroundStyle(Color.textSecondary)
                    .multilineTextAlignment(.center)

                AppButton(title: "Coba Lagi") {
                    Task {
                        await viewModel.createNewSession()
                    }
                }
            }
            .frame(maxWidth: 320)

        case .joined, .completed:
            EmptyView()
        }
    }

    @ViewBuilder
    private var qrCode: some View {
        if let qrImage = viewModel.qrImage {
            Image(uiImage: qrImage)
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .padding(Spacing.lg)
                .frame(width: 300, height: 300)
                .background(Color.bgCard)
                .clipShape(RoundedRectangle(cornerRadius: Radius.md))
                .overlay {
                    RoundedRectangle(cornerRadius: Radius.md)
                        .stroke(
                            Color.textPrimary,
                            style: StrokeStyle(
                                lineWidth: 2,
                                lineCap: .round,
                                dash: [7, 7]
                            )
                        )
                }
                .accessibilityLabel("Kode QR untuk bergabung ke sesi")
        }
    }

    private func showWaitingState() {
        isShowingHatedTopics = false
        flowStep = .waitingForPartner
    }

    private func printCombinedPreferencesIfNeeded() {
        guard viewModel.state == .completed,
              hostHasCompletedPreferences,
              !hasPrintedCombinedPreferences else {
            return
        }

        hasPrintedCombinedPreferences = true

        let appClipSelectedTopicIDs = Set(
            viewModel.receivedSelectedTopicIDs
        )
        let appClipHatedTopicIDs = Set(
            viewModel.receivedHatedTopicIDs
        )
        let combinedSelectedTopicIDs = selectedTopicIDs
            .union(appClipSelectedTopicIDs)
        let combinedHatedTopicIDs = hatedTopicIDs
            .union(appClipHatedTopicIDs)
        let availableTopicIDs = combinedSelectedTopicIDs
            .subtracting(combinedHatedTopicIDs)

        let availableTopics = Topics.all
            .filter { availableTopicIDs.contains($0.id) }
            .map { "\($0.id): \($0.name)" }

        let output = availableTopics.isEmpty
            ? "Tidak ada topik yang tersedia"
            : availableTopics.joined(separator: ", ")

        print("AppClip combined preferences: [\(output)]")
    }
}

//#Preview {
//    QRView()
//}
