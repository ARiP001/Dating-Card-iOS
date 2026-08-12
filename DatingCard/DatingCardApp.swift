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
            ContentView()
                .preferredColorScheme(.light)
        }
        .modelContainer(for: [
                  CardModel.self,
                  SessionModel.self
              ])
    }
}
