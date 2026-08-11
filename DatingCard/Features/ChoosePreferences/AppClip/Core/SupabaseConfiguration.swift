//
//  Untitled.swift
//  DatingCard
//
//  Created by Arif Fathurrahman on 10/08/26.
//

import Foundation

enum SupabaseConfiguration {
    static let projectURL = URL(
        string: "https://hiyquhaxudljkmmsipey.supabase.co"
    )!

    static let publishableKey = "sb_publishable_rsRilC8E-CyvUxai3bzNOg_XTnxoJZP"

    static var sessionsEndpoint: URL {
        projectURL
            .appendingPathComponent("rest/v1")
            .appendingPathComponent("conversation_sessions")
    }
}
