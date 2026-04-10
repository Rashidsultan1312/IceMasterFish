import SwiftUI

struct TeamsSectionHeaderView: View {
    let iconImageName: String
    let titleKey: String
    @EnvironmentObject private var loc: LocalizationService

    var body: some View {
        HStack(spacing: 12) {
            Image(iconImageName)
                .resizable()
                .scaledToFit()
                .frame(width: 36, height: 36)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            Text(loc.localized(titleKey))
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(ColorPalette.squadHeading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    TeamsSectionHeaderView(iconImageName: "SectionSquadsIcon", titleKey: "teams.section.squads")
        .environmentObject(LocalizationService.shared)
        .padding()
}
