import SwiftUI

struct SessionExitConfirmation: View {
    var title: String = "Akhiri sesi"
    var message: String = "Kalian masih memiliki kartu yang belum dimainkan. Jika sesi diakhiri, kamu dapat melanjutkannya kembali melalui riwayat sesi."
    var continueTitle: String = "Lanjutkan bermain"
    var exitTitle: String = "Akhiri sesi"
    let onContinue: () -> Void
    let onExit: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.7).ignoresSafeArea()
            VStack(alignment: .leading, spacing: Spacing.lg) {
                Text(title).font(AppFont.title2Bold)
                Text(message)
                    .font(AppFont.title3Regular).foregroundStyle(Color.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                AppButton(title: continueTitle, action: onContinue)
                Button(action: onExit) {
                    Text(exitTitle).font(AppFont.headlineSemibold).foregroundStyle(.red)
                        .frame(maxWidth: .infinity).padding(.vertical, Spacing.md)
                        .background(Color.surfaceSecondary).clipShape(RoundedRectangle(cornerRadius: Radius.clickable))
                }.buttonStyle(.plain)
            }
            .padding(Spacing.xl).background(Color.bgCard)
            .clipShape(RoundedRectangle(cornerRadius: Radius.xl)).padding(Spacing.lg)
        }
    }
}
