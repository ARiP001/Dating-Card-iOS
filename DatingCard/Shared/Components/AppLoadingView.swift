//
//  AppLoadingView.swift
//  DatingCard
//

import SwiftUI

struct AppLoadingView: View {
    let message: String

    var body: some View {
        VStack(spacing: Spacing.md) {
            ProgressView()
                .tint(Color.accentPrimary)

            Text(message)
                .font(AppFont.caption1Regular)
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(Spacing.lg)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    AppLoadingView(message: "Menunggu perangkat lain menyelesaikan pilihannya")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bgPrimary)
}
