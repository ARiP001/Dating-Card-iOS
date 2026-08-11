//
//  AppClipInvocationRouter.swift
//  DatingCard
//
//  Created by Arif Fathurrahman on 10/08/26.
//

//
//  AppClipInvocationRouter.swift
//  AppClipPOC
//
//  Created by Arif Fathurrahman on 06/08/26.
//

import Foundation
import Combine

@MainActor
final class AppClipInvocationRouter: ObservableObject {
    @Published private(set) var invocation: AppClipInvocation?
    @Published private(set) var statusMessage = "Menunggu invocation URL"

    func handle(_ activity: NSUserActivity) {
        guard activity.activityType == NSUserActivityTypeBrowsingWeb else {
            statusMessage = "Jenis user activity tidak didukung"
            return
        }

        guard let url = activity.webpageURL else {
            statusMessage = "Invocation URL tidak ditemukan"
            return
        }

        handle(url)
    }

    func handle(_ url: URL) {
        invocation = AppClipInvocation(url: url)
        statusMessage = "Invocation URL berhasil diterima"

        print("""
        ────────────────────────────────────
        APP CLIP INVOCATION
        URL       : \(url.absoluteString)
        Session ID: \(invocation?.sessionID ?? "-")
        ────────────────────────────────────
        """)
    }

    func loadFallbackURLForPreview() {
        guard invocation == nil,
              let url = URL(
                string: "https://easyconvo.com/join?session=PREVIEW123"
              )
        else {
            return
        }

        handle(url)
    }
}
