//
//  PreferenceChoose.swift
//  DatingCard
//
//  Created by Arif Fathurrahman on 10/08/26.
//

import SwiftUI

struct PreferenceChooseContentView: View {
    @StateObject private var viewModel =
    PreferencesAppClipViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    header
                    content
                }
                .padding()
            }
            .navigationTitle("Conversation Session")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                if viewModel.sessionID == nil {
                    await viewModel.createNewSession()
                }
            }
            .onDisappear {
                viewModel.stopPolling()
            }
        }
    }

    private var header: some View {
        VStack(spacing: 10) {
            Image(systemName: "person.2.fill")
                .font(.system(size: 48))
                .foregroundStyle(.blue)

            Text("Start a Conversation")
                .font(.title2.bold())

            Text(
                "Ask the second person to scan this QR code."
            )
            .multilineTextAlignment(.center)
            .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .creating:
            loadingView

        case .waiting:
            waitingView

        case .completed:
            completedView

        case let .failed(message):
            errorView(message: message)
        }
    }

    private var loadingView: some View {
        VStack(spacing: 14) {
            ProgressView()

            Text("Creating session…")
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 40)
    }

    private var waitingView: some View {
        VStack(spacing: 22) {
            qrCard

            HStack(spacing: 10) {
                ProgressView()

                Text("Waiting for App Clip response…")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Button {
                Task {
                    await viewModel.createNewSession()
                }
            } label: {
                Label(
                    "Create New Session",
                    systemImage: "arrow.clockwise"
                )
            }
            .buttonStyle(.bordered)
        }
    }

    private var qrCard: some View {
        VStack(spacing: 16) {
            if let qrImage = viewModel.qrImage {
                Image(uiImage: qrImage)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: 250,
                        height: 250
                    )
                    .padding(14)
                    .background(.white)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 20,
                            style: .continuous
                        )
                    )
            }

            if let sessionID = viewModel.sessionID {
                VStack(spacing: 5) {
                    Text("Session ID")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text(sessionID)
                        .font(
                            .title3
                                .bold()
                                .monospaced()
                        )
                }
            }

            if let url = viewModel.invocationURL {
                Text(url.absoluteString)
                    .font(.caption.monospaced())
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .textSelection(.enabled)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.thinMaterial)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 24,
                style: .continuous
            )
        )
    }
    
    private var completedView: some View {
        VStack(spacing: 24) {

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(.green)

            VStack(spacing: 6) {
                Text("Preferences Received")
                    .font(.title2.bold())

                if let sessionID = viewModel.sessionID {
                    Text("Session \(sessionID)")
                        .font(.caption.monospaced())
                        .foregroundStyle(.secondary)
                }
            }

            // Selected Topics

            VStack(
                alignment: .leading,
                spacing: 12
            ) {
                Text("Topics they want to discuss")
                    .font(.headline)

                if viewModel.receivedSelectedTopics.isEmpty {

                    Text("No selected topics")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                } else {

                    ForEach(
                        viewModel.receivedSelectedTopics
                    ) { topic in

                        HStack(spacing: 12) {

                            Image(
                                systemName: topic.systemImage
                            )
                            .frame(width: 24)
                            .foregroundStyle(.blue)

                            Text(topic.title)
                                .font(.body.weight(.medium))

                            Spacer()

                            Image(
                                systemName: "checkmark.circle.fill"
                            )
                            .foregroundStyle(.green)
                        }
                        .padding()
                        .background(
                            Color.secondary.opacity(0.08)
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 14,
                                style: .continuous
                            )
                        )
                    }
                }
            }
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )

            // Hated Topics

            VStack(
                alignment: .leading,
                spacing: 12
            ) {
                Text("Topics they prefer to avoid")
                    .font(.headline)

                if viewModel.receivedHatedTopics.isEmpty {

                    Text("No avoided topics")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                } else {

                    ForEach(
                        viewModel.receivedHatedTopics
                    ) { topic in

                        HStack(spacing: 12) {

                            Image(
                                systemName: topic.systemImage
                            )
                            .frame(width: 24)
                            .foregroundStyle(.red)

                            Text(topic.title)
                                .font(.body.weight(.medium))

                            Spacer()

                            Image(
                                systemName: "xmark.circle.fill"
                            )
                            .foregroundStyle(.red)
                        }
                        .padding()
                        .background(
                            Color.red.opacity(0.08)
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 14,
                                style: .continuous
                            )
                        )
                    }
                }
            }
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )

            Button {
                Task {
                    await viewModel.createNewSession()
                }
            } label: {
                Label(
                    "Start New Session",
                    systemImage: "plus"
                )
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
    }

    private func errorView(
        message: String
    ) -> some View {
        VStack(spacing: 18) {
            Image(
                systemName: "exclamationmark.triangle.fill"
            )
            .font(.system(size: 52))
            .foregroundStyle(.orange)

            Text("Something went wrong")
                .font(.title3.bold())

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button("Try Again") {
                if viewModel.sessionID == nil {
                    Task {
                        await viewModel.createNewSession()
                    }
                } else {
                    viewModel.retryPolling()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(.vertical, 30)
    }
}
