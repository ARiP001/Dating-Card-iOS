//
//  DatingCardApp.swift
//  DatingCard
//
//  Created by Arif Fathurrahman on 10/08/26.
//

import SwiftUI
import SwiftData

@main
struct DatingCardApp: App {
    var body: some Scene {
        WindowGroup {
            WouldYouRatherView(
                      topicIDs: [1, 2, 3, 4, 5]
                  )
//            ContentView()
//            PreferenceChooseContentView()
        }
        .modelContainer(for: [
                  CardModel.self,
                  SessionModel.self
              ])
    }
}
