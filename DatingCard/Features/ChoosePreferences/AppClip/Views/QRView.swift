//
//  QRView.swift
//  DatingCard
//

import SwiftUI

struct QRView: View {
    private enum FlowStep {
        case preferences
        case hatedTopics
        case waitingForPartner
    }

    @StateObject private var viewModel = FullAppViewModel()

    @State private var selectedTopicIDs: Set<Int> = []
    @State private var hatedTopicIDs: Set<Int> = []
    @State private var flowStep: FlowStep = .preferences

    var onClose: () -> Void = { }
    var onPreferencesCompleted: (Set<Int>, Set<Int>) -> Void = { _, _ in }

    var body: some View {
        Group {
            if viewModel.state == .completed {
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
        .background(Color.bgPrimary.ignoresSafeArea())
        .task {
            if viewModel.sessionID == nil {
                await viewModel.createNewSession()
            }
        }
    }

    private var partnerHasJoined: Bool {
        switch viewModel.state {
        case .joined:
            return true
        default:
            return false
        }
    }

    @ViewBuilder
    private var preferencesContent: some View {
        switch flowStep {
        case .preferences:
            QRPreferencesChooseView(
                selectedTopicIDs: $selectedTopicIDs,
                onContinue: {
                    hatedTopicIDs.subtract(selectedTopicIDs)
                    flowStep = .hatedTopics
                }
            )

        case .hatedTopics:
            QRHatedChooseView(
                selectedTopicIDs: selectedTopicIDs,
                hatedTopicIDs: $hatedTopicIDs,
                onBack: {
                    flowStep = .preferences
                },
                onSubmit: {
                    showWaitingState()
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
        GeometryReader { geometry in
            ZStack(alignment: .topTrailing) {
                VStack(spacing: Spacing.xl) {
                    Spacer(minLength: geometry.size.height * 0.14)

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

                closeButton
                    .padding(.top, Spacing.md)
                    .padding(.trailing, Spacing.lg)
            }
        }
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

    private var closeButton: some View {
        Button {
            viewModel.stopPolling()
            onClose()
        } label: {
            Image(systemName: "xmark")
                .font(.title2.weight(.medium))
                .foregroundStyle(Color.textPrimary)
                .frame(width: 44, height: 44)
                .background(Color.bgCard)
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .stroke(Color.border, lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Tutup")
    }

    private func showWaitingState() {
        flowStep = .waitingForPartner
    }
}

//#Preview {
//    QRView()
//}
