//
//  AppConfirmationAlert.swift
//  DatingCard
//

import SwiftUI

struct AppConfirmationAlert: View {
    let title: String
    let message: String
    let accentColor: Color
    let confirmTitle: String
    let cancelTitle: String?
    let onConfirm: () -> Void
    let onCancel: (() -> Void)?

    init(
        title: String,
        message: String,
        accentColor: Color,
        confirmTitle: String = "Oke",
        cancelTitle: String? = nil,
        onConfirm: @escaping () -> Void,
        onCancel: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.accentColor = accentColor
        self.confirmTitle = confirmTitle
        self.cancelTitle = cancelTitle
        self.onConfirm = onConfirm
        self.onCancel = onCancel
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text(title)
                    .font(AppFont.bodyBold)
                    .foregroundStyle(Color.textPrimary)

                Text(message)
                    .font(AppFont.bodyRegular)
                    .foregroundStyle(Color.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            AppButton(
                title: confirmTitle,
                accentColor: accentColor,
                action: onConfirm
            )

            if let cancelTitle, let onCancel {
                Button(action: onCancel) {
                    Text(cancelTitle)
                        .font(AppFont.headlineSemibold)
                        .foregroundStyle(Color.accentPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.md)
                        .background(Color.bgPrimary)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: Radius.clickable
                            )
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(Spacing.lg)
        .frame(maxWidth: 330)
        .background(Color.bgCard)
        .clipShape(RoundedRectangle(cornerRadius: Radius.xl))
    }
}

#Preview {
    ZStack {
        Color.textPrimary.opacity(0.45)
            .ignoresSafeArea()

        AppConfirmationAlert(
            title: "Permainan Terakhir",
            message: "Apakah kamu ingin melanjutkan permainan sebelumnya?",
            accentColor: .accentDustyMauve,
            confirmTitle: "Lanjutkan bermain",
            cancelTitle: "Tidak",
            onConfirm: { },
            onCancel: { }
        )
    }
}
