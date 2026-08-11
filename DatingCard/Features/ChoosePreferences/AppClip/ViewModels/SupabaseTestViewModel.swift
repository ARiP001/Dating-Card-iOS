//
//  SupabaseTestViewModel.swift
//  DatingCard
//
//  Created by Arif Fathurrahman on 10/08/26.
//

import Foundation
import Combine

@MainActor
final class SupabaseTestViewModel: ObservableObject {

    enum TestState: Equatable {
        case idle
        case running
        case success
        case failed
    }

    struct TestLog: Identifiable, Equatable {

        enum Status {
            case waiting
            case running
            case success
            case failed
        }

        let id = UUID()

        let title: String
        var detail: String
        var status: Status
    }

    @Published private(set) var state: TestState = .idle

    @Published private(set) var logs: [TestLog] = []

    @Published private(set) var testSessionID: String?

    @Published private(set) var fetchedSession: ConversationSession?

    @Published private(set) var errorMessage: String?

    private let service = SessionService()

    var projectHost: String {
        SupabaseConfiguration.projectURL.host ?? "-"
    }

    var endpointText: String {
        SupabaseConfiguration.sessionsEndpoint.absoluteString
    }

    // MARK: - Complete Test

    func runCompleteTest() async {

        guard state != .running else {
            return
        }

        reset()

        state = .running

        let sessionID =
            "TEST-\(UUID().uuidString.prefix(8).uppercased())"

        testSessionID = sessionID

        do {

            // MARK: 1. CREATE

            appendRunningLog(
                title: "1. Create session",
                detail: "Mengirim INSERT ke Supabase"
            )

            try await service.createSession(
                id: sessionID
            )

            markLatestLogSuccess(
                detail:
                    "Session \(sessionID) berhasil dibuat"
            )

            // MARK: 2. FETCH

            appendRunningLog(
                title: "2. Fetch session",
                detail: "Membaca session yang baru dibuat"
            )

            let createdSession =
                try await service.fetchSession(
                    id: sessionID
                )

            fetchedSession = createdSession

            markLatestLogSuccess(
                detail: """
                Session ditemukan
                Status: \(createdSession.status)
                Selected: \(createdSession.selectedTopics)
                Hated: \(createdSession.hatedTopics)
                """
            )

            // MARK: 3. UPDATE

            appendRunningLog(
                title: "3. Update preferences",
                detail:
                    "Mengirim selected_topics dan hated_topics"
            )

            let testSelectedTopics: [Int] = [
                1,
                3,
                5
            ]

            let testHatedTopics: [Int] = [
                2,
                4
            ]

            try await service.submitPreferences(
                sessionID: sessionID,
                selectedTopics: testSelectedTopics,
                hatedTopics: testHatedTopics
            )

            markLatestLogSuccess(
                detail: """
                Preferences berhasil diperbarui

                Selected:
                \(testSelectedTopics)

                Hated:
                \(testHatedTopics)
                """
            )

            // MARK: 4. VERIFY

            appendRunningLog(
                title: "4. Verify update",
                detail:
                    "Membaca ulang data setelah update"
            )

            let updatedSession =
                try await service.fetchSession(
                    id: sessionID
                )

            fetchedSession = updatedSession

            guard updatedSession.status ==
                    "completed"
            else {

                throw SupabaseDebugError
                    .invalidStatus(
                        updatedSession.status
                    )
            }

            guard updatedSession.selectedTopics ==
                    testSelectedTopics
            else {

                throw SupabaseDebugError
                    .invalidSelectedTopics(
                        updatedSession.selectedTopics
                    )
            }

            guard updatedSession.hatedTopics ==
                    testHatedTopics
            else {

                throw SupabaseDebugError
                    .invalidHatedTopics(
                        updatedSession.hatedTopics
                    )
            }

            markLatestLogSuccess(
                detail: """
                Update terverifikasi

                Status:
                \(updatedSession.status)

                Selected:
                \(updatedSession.selectedTopics.map(String.init).joined(separator: ", "))

                Hated:
                \(updatedSession.hatedTopics.map(String.init).joined(separator: ", "))
                """
            )

            // MARK: 5. DELETE

            appendRunningLog(
                title: "5. Delete test session",
                detail:
                    "Membersihkan data pengujian"
            )

            try await service.deleteSession(
                id: sessionID
            )

            markLatestLogSuccess(
                detail:
                    "Session test berhasil dihapus"
            )

            state = .success

        } catch {

            markLatestLogFailed(
                detail:
                    error.localizedDescription
            )

            errorMessage =
                error.localizedDescription

            state = .failed
        }
    }

    // MARK: - Reset

    func reset() {

        logs = []

        testSessionID = nil

        fetchedSession = nil

        errorMessage = nil

        state = .idle
    }

    // MARK: - Logging

    private func appendRunningLog(
        title: String,
        detail: String
    ) {

        logs.append(
            TestLog(
                title: title,
                detail: detail,
                status: .running
            )
        )
    }

    private func markLatestLogSuccess(
        detail: String
    ) {

        guard !logs.isEmpty else {
            return
        }

        logs[logs.count - 1]
            .status = .success

        logs[logs.count - 1]
            .detail = detail
    }

    private func markLatestLogFailed(
        detail: String
    ) {

        guard !logs.isEmpty else {

            logs.append(
                TestLog(
                    title: "Test failed",
                    detail: detail,
                    status: .failed
                )
            )

            return
        }

        logs[logs.count - 1]
            .status = .failed

        logs[logs.count - 1]
            .detail = detail
    }
}

// MARK: - Debug Errors

private enum SupabaseDebugError:
    LocalizedError {

    case invalidStatus(String)

    case invalidSelectedTopics(
        [Int]
    )

    case invalidHatedTopics(
        [Int]
    )

    var errorDescription: String? {

        switch self {

        case let .invalidStatus(status):

            return """
            Status hasil update tidak sesuai:
            \(status)
            """

        case let .invalidSelectedTopics(topics):

            return """
            selected_topics hasil update tidak sesuai:

            \(topics.map(String.init).joined(separator: ", "))
            """

        case let .invalidHatedTopics(topics):

            return """
            hated_topics hasil update tidak sesuai:

            \(topics.map(String.init).joined(separator: ", "))
            """
        }
    }
}
