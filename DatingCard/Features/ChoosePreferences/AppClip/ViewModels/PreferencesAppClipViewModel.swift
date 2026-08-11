//
//  P.swift
//  DatingCard
//
//  Created by Arif Fathurrahman on 10/08/26.
//

import Foundation
import UIKit
import Combine

@MainActor
final class FullAppViewModel: ObservableObject {

    enum State: Equatable {
        case idle
        case creating

        /// QR belum dibuka partner.
        case waiting

        /// App Clip sudah dibuka,
        /// tetapi preferences belum selesai.
        case joined

        /// Preferences sudah dikirim.
        case completed

        case failed(String)
    }

    // MARK: - Published State

    @Published private(set)
    var state: State = .idle

    @Published private(set)
    var sessionID: String?

    @Published private(set)
    var invocationURL: URL?

    @Published private(set)
    var qrImage: UIImage?

    @Published private(set)
    var receivedSelectedTopicIDs: [Int] = []

    @Published private(set)
    var receivedHatedTopicIDs: [Int] = []

    // MARK: - Converted Topics

    var receivedSelectedTopics: [ConversationTopic] {
        receivedSelectedTopicIDs.compactMap {
            ConversationTopic.topic(for: $0)
        }
    }

    var receivedHatedTopics: [ConversationTopic] {
        receivedHatedTopicIDs.compactMap {
            ConversationTopic.topic(for: $0)
        }
    }

    // MARK: - Dependencies

    private let service = SessionService()

    private var pollingTask:
        Task<Void, Never>?

    deinit {
        pollingTask?.cancel()
    }

    // MARK: - Create Session

    func createNewSession() async {
        pollingTask?.cancel()
        pollingTask = nil

        state = .creating

        sessionID = nil
        invocationURL = nil
        qrImage = nil

        receivedSelectedTopicIDs = []
        receivedHatedTopicIDs = []

        let id = Self.makeSessionID()

        guard let url = URL(
            string:
                "https://easyconvo.com/join?session=\(id)"
        ) else {
            state = .failed(
                "Gagal membuat invocation URL."
            )

            return
        }

        do {
            try await service.createSession(
                id: id
            )

            sessionID = id

            invocationURL = url

            qrImage = QRCodeGenerator.generate(
                from: url.absoluteString
            )

            print(
                "QR INVOCATION URL:",
                url.absoluteString
            )

            state = .waiting

            startPolling(
                sessionID: id
            )

        } catch {
            state = .failed(
                error.localizedDescription
            )
        }
    }

    // MARK: - Polling

    private func startPolling(
        sessionID: String
    ) {
        pollingTask?.cancel()

        pollingTask = Task { [weak self] in
            guard let self else {
                return
            }

            while !Task.isCancelled {
                do {
                    let session =
                        try await service.fetchSession(
                            id: sessionID
                        )

                    try Task.checkCancellation()

                    switch session.status {

                    case "waiting":
                        state = .waiting

                    case "joined":
                        state = .joined

                    case "completed":
                        receivedSelectedTopicIDs =
                            session.selectedTopics

                        receivedHatedTopicIDs =
                            session.hatedTopics

                        state = .completed

                        pollingTask = nil

                        return

                    default:
                        print(
                            "Unknown session status:",
                            session.status
                        )
                    }

                } catch is CancellationError {
                    return

                } catch {
                    state = .failed(
                        error.localizedDescription
                    )

                    pollingTask = nil

                    return
                }

                do {
                    try await Task.sleep(
                        for: .seconds(2)
                    )

                } catch {
                    return
                }
            }
        }
    }

    // MARK: - Retry

    func retryPolling() {
        guard let sessionID else {
            return
        }

        state = .waiting

        startPolling(
            sessionID: sessionID
        )
    }

    // MARK: - Stop

    func stopPolling() {
        pollingTask?.cancel()

        pollingTask = nil
    }

    // MARK: - Session ID

    private static func makeSessionID() -> String {
        String(
            UUID()
                .uuidString
                .replacingOccurrences(
                    of: "-",
                    with: ""
                )
                .prefix(8)
        )
        .uppercased()
    }
}
