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
                .font(AppFont.title1Bold)
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(Spacing.lg)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    AppLoadingView(message: "Menyiapkan sesi...")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bgPrimary)
}
