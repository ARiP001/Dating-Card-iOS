//
//  SupabaseTestView.swift
//  DatingCard
//
//  Created by Arif Fathurrahman on 10/08/26.
//

import SwiftUI

struct SupabaseTestView: View {
    @StateObject private var viewModel =
        SupabaseTestViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    connectionCard
                    actionSection
                    statusCard
                    logSection

                    if let session = viewModel.fetchedSession {
                        sessionResultCard(session)
                    }
                }
                .padding()
            }
            .navigationTitle("Supabase Test")
            .navigationBarTitleDisplayMode(.inline)
            .alert(
                "Supabase Error",
                isPresented: errorBinding
            ) {
                Button("OK", role: .cancel) {
                    viewModel.reset()
                }
            } message: {
                Text(viewModel.errorMessage ?? "Unknown error")
            }
        }
    }

    private var connectionCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label(
                "Supabase Configuration",
                systemImage: "server.rack"
            )
            .font(.headline)

            informationRow(
                title: "Project host",
                value: viewModel.projectHost
            )

            Divider()

            VStack(alignment: .leading, spacing: 5) {
                Text("REST endpoint")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(viewModel.endpointText)
                    .font(.caption.monospaced())
                    .textSelection(.enabled)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
            }

            HStack(spacing: 8) {
                Image(systemName: keyStatusIcon)

                Text(keyStatusText)
                    .font(.caption)
            }
            .foregroundStyle(keyStatusStyle)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thinMaterial)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 20,
                style: .continuous
            )
        )
    }

    private var actionSection: some View {
        VStack(spacing: 12) {
            Button {
                Task {
                    await viewModel.runCompleteTest()
                }
            } label: {
                HStack(spacing: 10) {
                    if viewModel.state == .running {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Image(systemName: "play.fill")
                    }

                    Text(
                        viewModel.state == .running
                            ? "Testing Supabase..."
                            : "Run Complete Test"
                    )
                    .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 5)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(
                viewModel.state == .running ||
                !isConfigurationValid
            )

            Button("Reset Test") {
                viewModel.reset()
            }
            .buttonStyle(.bordered)
            .disabled(viewModel.state == .running)
        }
    }

    private var statusCard: some View {
        HStack(spacing: 14) {
            Image(systemName: statusIcon)
                .font(.title2)
                .foregroundStyle(statusStyle)

            VStack(alignment: .leading, spacing: 3) {
                Text(statusTitle)
                    .font(.headline)

                Text(statusDescription)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(statusStyle.opacity(0.1))
        .clipShape(
            RoundedRectangle(
                cornerRadius: 18,
                style: .continuous
            )
        )
    }

    @ViewBuilder
    private var logSection: some View {
        if !viewModel.logs.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text("Test Log")
                    .font(.headline)

                ForEach(viewModel.logs) { log in
                    testLogRow(log)
                }
            }
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
        }
    }

    private func testLogRow(
        _ log: SupabaseTestViewModel.TestLog
    ) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Group {
                switch log.status {
                case .waiting:
                    Image(systemName: "circle")

                case .running:
                    ProgressView()

                case .success:
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)

                case .failed:
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.red)
                }
            }
            .frame(width: 24, height: 24)

            VStack(alignment: .leading, spacing: 4) {
                Text(log.title)
                    .font(.subheadline.weight(.semibold))

                Text(log.detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .textSelection(.enabled)
            }

            Spacer()
        }
        .padding()
        .background(
            Color.secondary.opacity(0.07)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 14,
                style: .continuous
            )
        )
    }
    
    private func sessionResultCard(
        _ session: ConversationSession
    ) -> some View {
        VStack(alignment: .leading, spacing: 14) {

            Label(
                "Latest Database Result",
                systemImage: "cylinder.split.1x2"
            )
            .font(.headline)

            informationRow(
                title: "ID",
                value: session.id
            )

            informationRow(
                title: "Status",
                value: session.status
            )

            Divider()

            // Selected Topics

            VStack(alignment: .leading, spacing: 8) {
                Text("Selected topics")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                if session.selectedTopics.isEmpty {

                    Text("No topics")
                        .font(.subheadline)

                } else {

                    ForEach(
                        session.selectedTopics,
                        id: \.self
                    ) { topicID in

                        if let topic =
                            ConversationTopic.topic(for: topicID) {

                            Label(
                                topic.title,
                                systemImage: "checkmark.circle.fill"
                            )
                            .font(.subheadline)
                            .foregroundStyle(.green)
                        }
                    }
                }
            }

            Divider()

            // Hated Topics

            VStack(alignment: .leading, spacing: 8) {
                Text("Hated topics")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                if session.hatedTopics.isEmpty {

                    Text("No hated topics")
                        .font(.subheadline)

                } else {

                    ForEach(
                        session.hatedTopics,
                        id: \.self
                    ) { topicID in

                        if let topic =
                            ConversationTopic.topic(for: topicID) {

                            Label(
                                topic.title,
                                systemImage: "xmark.circle.fill"
                            )
                            .font(.subheadline)
                            .foregroundStyle(.red)
                        }
                    }
                }
            }
        }
        .padding()
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .background(.thinMaterial)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 20,
                style: .continuous
            )
        )
    }

    private func informationRow(
        title: String,
        value: String
    ) -> some View {
        HStack(alignment: .top, spacing: 16) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .font(.subheadline.weight(.medium))
                .multilineTextAlignment(.trailing)
                .textSelection(.enabled)
        }
    }

    private var isConfigurationValid: Bool {
        !SupabaseConfiguration.publishableKey.isEmpty &&
        !SupabaseConfiguration.publishableKey.contains("YOUR_") &&
        SupabaseConfiguration.projectURL.host != nil
    }

    private var keyStatusText: String {
        isConfigurationValid
            ? "Publishable key configured"
            : "Publishable key belum dikonfigurasi"
    }

    private var keyStatusIcon: String {
        isConfigurationValid
            ? "checkmark.shield.fill"
            : "exclamationmark.triangle.fill"
    }

    private var keyStatusStyle: Color {
        isConfigurationValid ? .green : .orange
    }

    private var statusIcon: String {
        switch viewModel.state {
        case .idle:
            return "circle.dashed"

        case .running:
            return "arrow.triangle.2.circlepath"

        case .success:
            return "checkmark.circle.fill"

        case .failed:
            return "xmark.circle.fill"
        }
    }

    private var statusTitle: String {
        switch viewModel.state {
        case .idle:
            return "Ready to Test"

        case .running:
            return "Running Test"

        case .success:
            return "Supabase Works"

        case .failed:
            return "Test Failed"
        }
    }

    private var statusDescription: String {
        switch viewModel.state {
        case .idle:
            return "Tekan Run Complete Test."

        case .running:
            return "Menjalankan insert, select, update, dan delete."

        case .success:
            return "Semua operasi database berhasil."

        case .failed:
            return "Periksa error dan konfigurasi Supabase."
        }
    }

    private var statusStyle: Color {
        switch viewModel.state {
        case .idle:
            return .secondary

        case .running:
            return .blue

        case .success:
            return .green

        case .failed:
            return .red
        }
    }

    private var errorBinding: Binding<Bool> {
        Binding(
            get: {
                viewModel.errorMessage != nil
            },
            set: { isPresented in
                if !isPresented {
                    viewModel.reset()
                }
            }
        )
    }
}
