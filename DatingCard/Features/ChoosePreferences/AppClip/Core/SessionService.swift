//
//  SessionService.swift
//  DatingCard
//
//  Created by Arif Fathurrahman on 10/08/26.
//

import Foundation

enum SessionServiceError: LocalizedError {
    case invalidResponse
    case serverError(
        statusCode: Int,
        message: String
    )
    case sessionNotFound

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Respons server tidak valid."

        case let .serverError(statusCode, message):
            return "Server error \(statusCode): \(message)"

        case .sessionNotFound:
            return "Session tidak ditemukan."
        }
    }
}

struct SessionService {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: - Create Session

    func createSession(
        id: String
    ) async throws {
        var request = URLRequest(
            url: SupabaseConfiguration.sessionsEndpoint
        )

        request.httpMethod = "POST"

        applyCommonHeaders(to: &request)

        request.setValue(
            "return=minimal",
            forHTTPHeaderField: "Prefer"
        )

        let body = CreateSessionRequest(
            id: id,
            selectedTopics: [],
            hatedTopics: [],
            status: "waiting"
        )

        request.httpBody =
            try JSONEncoder().encode(body)

        let (data, response) =
            try await session.data(for: request)

        try validate(
            response: response,
            data: data,
            validStatusCodes: 200...299
        )
    }

    // MARK: - Fetch

    func fetchSession(
        id: String
    ) async throws -> ConversationSession {

        var components = URLComponents(
            url: SupabaseConfiguration.sessionsEndpoint,
            resolvingAgainstBaseURL: false
        )

        components?.queryItems = [
            URLQueryItem(
                name: "id",
                value: "eq.\(id)"
            ),
            URLQueryItem(
                name: "select",
                value: "*"
            )
        ]

        guard let url = components?.url else {
            throw SessionServiceError.invalidResponse
        }

        var request = URLRequest(url: url)

        request.httpMethod = "GET"

        applyCommonHeaders(to: &request)

        let (data, response) =
            try await session.data(for: request)

        try validate(
            response: response,
            data: data,
            validStatusCodes: 200...299
        )

        let decoder = JSONDecoder()

        decoder.dateDecodingStrategy = .iso8601

        let sessions = try decoder.decode(
            [ConversationSession].self,
            from: data
        )

        guard let session = sessions.first else {
            throw SessionServiceError.sessionNotFound
        }

        return session
    }

    // MARK: - Submit Preferences

    func submitPreferences(
        sessionID: String,
        selectedTopics: [Int],
        hatedTopics: [Int]
    ) async throws {

        var components = URLComponents(
            url: SupabaseConfiguration.sessionsEndpoint,
            resolvingAgainstBaseURL: false
        )

        components?.queryItems = [
            URLQueryItem(
                name: "id",
                value: "eq.\(sessionID)"
            )
        ]

        guard let url = components?.url else {
            throw SessionServiceError.invalidResponse
        }

        var request = URLRequest(url: url)

        request.httpMethod = "PATCH"

        applyCommonHeaders(to: &request)

        request.setValue(
            "return=minimal",
            forHTTPHeaderField: "Prefer"
        )

        let body = UpdatePreferencesRequest(
            selectedTopics: selectedTopics,
            hatedTopics: hatedTopics,
            status: "completed",
            updatedAt: ISO8601DateFormatter()
                .string(from: Date())
        )

        request.httpBody =
            try JSONEncoder().encode(body)

        let (data, response) =
            try await session.data(for: request)

        try validate(
            response: response,
            data: data,
            validStatusCodes: 200...299
        )
    }

    // MARK: - Delete

    func deleteSession(
        id: String
    ) async throws {

        var components = URLComponents(
            url: SupabaseConfiguration.sessionsEndpoint,
            resolvingAgainstBaseURL: false
        )

        components?.queryItems = [
            URLQueryItem(
                name: "id",
                value: "eq.\(id)"
            )
        ]

        guard let url = components?.url else {
            throw SessionServiceError.invalidResponse
        }

        var request = URLRequest(url: url)

        request.httpMethod = "DELETE"

        applyCommonHeaders(to: &request)

        request.setValue(
            "return=minimal",
            forHTTPHeaderField: "Prefer"
        )

        let (data, response) =
            try await session.data(for: request)

        try validate(
            response: response,
            data: data,
            validStatusCodes: 200...299
        )
    }

    // MARK: - Headers

    private func applyCommonHeaders(
        to request: inout URLRequest
    ) {
        request.setValue(
            SupabaseConfiguration.publishableKey,
            forHTTPHeaderField: "apikey"
        )

        request.setValue(
            "Bearer \(SupabaseConfiguration.publishableKey)",
            forHTTPHeaderField: "Authorization"
        )

        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        request.setValue(
            "application/json",
            forHTTPHeaderField: "Accept"
        )
    }

    // MARK: - Validation

    private func validate(
        response: URLResponse,
        data: Data,
        validStatusCodes: ClosedRange<Int>
    ) throws {

        guard let httpResponse =
                response as? HTTPURLResponse
        else {
            throw SessionServiceError.invalidResponse
        }

        print(
            "HTTP:",
            httpResponse.statusCode,
            httpResponse.url?.absoluteString ?? "-"
        )

        guard validStatusCodes.contains(
            httpResponse.statusCode
        ) else {

            let message = String(
                data: data,
                encoding: .utf8
            ) ?? "Unknown error"

            throw SessionServiceError.serverError(
                statusCode: httpResponse.statusCode,
                message: message
            )
        }
    }
}

// MARK: - Request Models

private struct CreateSessionRequest: Encodable {
    let id: String

    let selectedTopics: [Int]
    let hatedTopics: [Int]

    let status: String

    enum CodingKeys: String, CodingKey {
        case id

        case selectedTopics = "selected_topics"
        case hatedTopics = "hated_topics"

        case status
    }
}

private struct UpdatePreferencesRequest: Encodable {
    let selectedTopics: [Int]
    let hatedTopics: [Int]

    let status: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case selectedTopics = "selected_topics"
        case hatedTopics = "hated_topics"

        case status

        case updatedAt = "updated_at"
    }
}
