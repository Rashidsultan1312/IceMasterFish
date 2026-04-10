import SwiftUI

struct AIToolCardView: View {
    @EnvironmentObject private var loc: LocalizationService
    let iconImageName: String
    let titleKey: String
    let subtitleKey: String
    let blobGradient: [Color]
    var action: () -> Void = {}

    private let corner: CGFloat = 28

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: corner, style: .continuous)
                    .fill(ColorPalette.background)

                Circle()
                    .fill(
                        LinearGradient(
                            colors: blobGradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .opacity(0.5)
                    .offset(x: 102, y: -15)

                HStack(alignment: .top, spacing: 12) {
                    Image(iconImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .background(ColorPalette.divider)
                        .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 4) {
                        Text(loc.localized(titleKey))
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(ColorPalette.aiCardTitle)
                        Text(loc.localized(subtitleKey))
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(ColorPalette.aiCardSubtitle)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(16)
            }
            .frame(maxWidth: .infinity, minHeight: 120, alignment: .leading)
            .overlay(
                RoundedRectangle(cornerRadius: corner, style: .continuous)
                    .stroke(ColorPalette.cardBorder, lineWidth: 1)
            )
            .clipped()
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    AIToolCardView(
        iconImageName: "AINameIcon",
        titleKey: "teams.ai.name.title",
        subtitleKey: "teams.ai.name.subtitle",
        blobGradient: [
            Color(red: 219 / 255, green: 234 / 255, blue: 254 / 255),
            Color(red: 239 / 255, green: 246 / 255, blue: 255 / 255)
        ]
    )
    .environmentObject(LocalizationService.shared)
    .padding()
}
