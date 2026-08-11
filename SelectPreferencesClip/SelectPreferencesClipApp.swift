//
//  SelectPreferencesClipApp.swift
//  SelectPreferencesClip
//
//  Created by Arif Fathurrahman on 10/08/26.
//

import SwiftUI

@main
struct AppClipPOCClipApp: App {
    @StateObject private var invocationRouter =
        AppClipInvocationRouter()

    var body: some Scene {
        WindowGroup {
            AppClipContentView()
                .environmentObject(invocationRouter)
                .onContinueUserActivity(
                    NSUserActivityTypeBrowsingWeb
                ) { activity in
                    invocationRouter.handle(activity)
                }
                .onOpenURL { url in
                    invocationRouter.handle(url)
                }
        }
    }
}

