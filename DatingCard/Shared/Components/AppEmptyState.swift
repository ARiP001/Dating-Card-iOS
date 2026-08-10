//
//  AppEmptyState.swift
//  DatingCard
//

import SwiftUI

struct AppEmptyState: View {
    let title: String
    var message: String?
    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {
        VStack(spacing: Spacing.lg) {
            CardStackIllustration()

            VStack(spacing: Spacing.sm) {
                Text(title)
                    .font(AppFont.title3Bold)
                    .foregroundStyle(Color.textPrimary)
                    .multilineTextAlignment(.center)

                if let message {
                    Text(message)
                        .font(AppFont.bodyRegular)
                        .foregroundStyle(Color.textSecondary)
                        .multilineTextAlignment(.center)
                }
            }

            if let actionTitle, let action {
                AppButton(title: actionTitle, action: action)
                    .frame(maxWidth: 320)
            }
        }
        .padding(Spacing.lg)
    }
}

#Preview {
    AppEmptyState(
        title: "Semua kartu sudah selesai dimainkan",
        message: "Kalian bisa kembali ke halaman utama.",
        actionTitle: "Home"
    ) { }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.bgPrimary)
}
