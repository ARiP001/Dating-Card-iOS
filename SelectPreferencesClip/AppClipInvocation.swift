//
//  Untitled.swift
//  DatingCard
//
//  Created by Arif Fathurrahman on 10/08/26.
//

//
//  AppClipInvocation.swift
//  AppClipPOC
//
//  Created by Arif Fathurrahman on 06/08/26.
//
import Foundation

struct AppClipInvocation: Equatable {
    let url: URL
    let sessionID: String
    let hostName: String?

    init(url: URL) {
        self.url = url
        self.hostName = url.host

        let components = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false
        )

        let sessionValue = components?
            .queryItems?
            .first(where: { $0.name == "session" })?
            .value

        self.sessionID = sessionValue?.isEmpty == false
            ? sessionValue!
            : "Session tidak ditemukan"
    }
}
