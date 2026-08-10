//
//  PreferencesSentView.swift
//  DatingCard
//
//  Created by Arif Fathurrahman on 10/08/26.
//

import SwiftUI

struct PreferencesSentView: View {

    var body: some View {

        VStack(spacing: 24) {

            Spacer()

            Image(
                systemName:
                    "checkmark.circle.fill"
            )
            .font(
                .system(size: 76)
            )
            .foregroundStyle(.green)

            VStack(spacing: 10) {

                Text(
                    "Preferences Sent"
                )
                .font(.title.bold())

                Text(
                    "Your preferences have been sent successfully."
                )
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(
                    .center
                )

                Text(
                    "Silakan kembali ke aplikasi utama."
                )
                .font(.headline)
                .multilineTextAlignment(
                    .center
                )
            }

            Spacer()

            Text(
                "You can close this App Clip."
            )
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(32)

        .navigationBarBackButtonHidden(
            true
        )
    }
}
