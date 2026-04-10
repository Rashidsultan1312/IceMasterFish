import SwiftUI
import UIKit

struct TeamCardView: View {
    @EnvironmentObject private var loc: LocalizationService
    let team: Team

    private let corner: CGFloat = 28

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top, spacing: 16) {
                    logoView
                        .frame(width: 64, height: 64)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(Color.white.opacity(0.35), lineWidth: 1)
                        )
                        .shadow(color: ColorPalette.teamLogoGlow, radius: 12, x: 0, y: 0)

                    VStack(alignment: .leading, spacing: 2) {
                        HStack(alignment: .center, spacing: 0) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(team.name)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(ColorPalette.squadHeading)

                                HStack(spacing: 4) {
                                    Image("TeamSkillBadge")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 14, height: 14)
                                    Text(loc.localized(team.leagueType.localizationKey).uppercased())
                                        .font(.system(size: 12, weight: .bold))
                                        .tracking(0.6)
                                        .foregroundColor(ColorPalette.teamRankText)
                                }
                            }

                            Spacer(minLength: 8)
                        }
                    }
                }

                HStack(spacing: 12) {
                    HStack(spacing: 6) {
                        Image("TeamMembersIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                        Text("\(team.players.count)")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(ColorPalette.teamStatNumber)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(ColorPalette.divider)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

                    Spacer()
                }
                .padding(.top, 12)
                .overlay(alignment: .top) {
                    Rectangle()
                        .fill(ColorPalette.divider)
                        .frame(height: 1)
                }
            }
            .padding(20)
        }
        .overlay(
            RoundedRectangle(cornerRadius: corner, style: .continuous)
                .stroke(ColorPalette.cardBorder, lineWidth: 1)
        )
    }

    @ViewBuilder
    private var logoView: some View {
        if let data = team.customLogoData, let ui = UIImage(data: data) {
            Image(uiImage: ui)
                .resizable()
                .scaledToFill()
        } else if let asset = team.presetImageAssetName() {
            Image(asset)
                .resizable()
                .scaledToFill()
        } else {
            Image("TeamCardLogoSample")
                .resizable()
                .scaledToFill()
        }
    }
}

#Preview {
    TeamCardView(team: .previewLakeWalkers)
        .environmentObject(LocalizationService.shared)
        .padding()
}
