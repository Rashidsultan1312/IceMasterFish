import SwiftUI

struct AppHeaderView: View {
    @EnvironmentObject private var loc: LocalizationService
    let titleKey: String
    var titleIconAssetName: String = "NavTitleDecor"
    var safeAreaTop: CGFloat = 0
    var onSettings: () -> Void = {}

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            HStack(spacing: 12) {
                Image(titleIconAssetName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .shadow(color: Color.black.opacity(0.06), radius: 2, x: 0, y: 1)

                Text(loc.localized(titleKey))
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(ColorPalette.background)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }

            Spacer(minLength: 8)

            Button(action: onSettings) {
                Image("NavSettings")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 46, height: 46)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 24)
        .padding(.top, safeAreaTop + 12)
        .padding(.bottom, 24)
        .frame(maxWidth: .infinity)
        .background(ColorPalette.navigationBarLinearGradient)
        .shadow(color: ColorPalette.shadowBlue.opacity(0.5), radius: 12, x: 0, y: 6)
    }
}

#Preview {
    AppHeaderView(titleKey: "tab.title.teams", safeAreaTop: 47)
        .environmentObject(LocalizationService.shared)
}
