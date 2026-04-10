import SwiftUI
import UIKit

struct TeamDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var loc: LocalizationService
    let teamId: UUID
    @ObservedObject var teamsViewModel: TeamsTabViewModel

    @State private var teamBeingEdited: Team?

    private var team: Team? {
        teamsViewModel.teams.first { $0.id == teamId }
    }

    private var deleteButtonGradient: LinearGradient {
        LinearGradient(
            colors: [
                ColorPalette.deleteButtonGradientStart,
                ColorPalette.deleteButtonGradientMid,
                ColorPalette.deleteButtonGradientEnd
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    var body: some View {
        Group {
            if let current = team {
                content(for: current)
            } else {
                Color.clear
                    .onAppear { dismiss() }
            }
        }
    }

    private func content(for team: Team) -> some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                AppScreenBackgroundView()
                
                VStack(spacing: 0) {
                    AppDetailNavigationBar(
                        topInset: geo.safeAreaInsets.top,
                        title: team.name,
                        backButtonImageName: "TeamDetailBack",
                        bottomPadding: 24,
                        shadowStyle: .softBlue
                    )
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 32) {
                            teamNameSection(team: team)
                            leagueSection(team: team)
                            teamIconSection()
                            logoPreviewSection(team: team)
                            rosterSection(team: team)
                            additionalInfoSection(team: team)
                            actionButtons(team: team)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 32)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .top)
        .fullScreenCover(item: $teamBeingEdited) { team in
            CreateTeamView(
                existingTeam: team,
                onSave: { updated in
                    teamsViewModel.replaceTeam(updated)
                },
                onAutosave: { updated in
                    teamsViewModel.replaceTeam(updated)
                }
            )
            .environmentObject(loc)
        }
    }

    private func teamNameSection(team: Team) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(loc.localized("create_team.field.team_name"))
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(ColorPalette.squadHeading)

            ZStack(alignment: .leading) {
                Text(team.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(ColorPalette.squadHeading)
                    .padding(.leading, 44)
                    .padding(.trailing, 16)
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(ColorPalette.background)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(ColorPalette.formFieldStrokeBold, lineWidth: 2)
                    )
                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)

                Image("TeamDetailNameFieldIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .padding(.leading, 16)
            }
        }
    }

    private func leagueSection(team: Team) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(loc.localized("create_team.field.league"))
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(ColorPalette.squadHeading)

            HStack(spacing: 6) {
                HStack(spacing: 8) {
                    Image("TeamDetailLeagueIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                    Text(loc.localized(team.leagueType.localizationKey))
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(ColorPalette.background)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(ColorPalette.leagueSegmentFill)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            }
            .padding(6)
            .background(ColorPalette.background)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(ColorPalette.formFieldStrokeBold, lineWidth: 2)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }

    private func teamIconSection() -> some View {
        HStack {
            Text(loc.localized("create_team.field.team_icon"))
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(ColorPalette.squadHeading)
            Spacer()
        }
    }

    private func logoPreviewSection(team: Team) -> some View {
        VStack(alignment: .center, spacing: 0) {
            ZStack {
                Circle()
                    .fill(ColorPalette.presetSelectedFill)
                    .frame(width: 128, height: 128)
                    .overlay(
                        Circle()
                            .strokeBorder(Color.white, lineWidth: 4)
                    )

                Group {
                    if let data = team.customLogoData, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                    } else if let asset = team.presetImageAssetName() {
                        Image(asset)
                            .resizable()
                            .scaledToFill()
                    }
                }
                .frame(width: 120, height: 120)
                .clipShape(Circle())
            }
            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 4)
            .shadow(color: Color.black.opacity(0.1), radius: 7, x: 0, y: 10)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(ColorPalette.background)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(ColorPalette.formFieldStrokeBold, lineWidth: 2)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }

    private func rosterSection(team: Team) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .bottom) {
                Text(loc.localized("create_team.roster.title"))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(ColorPalette.squadHeading)
                Spacer()
                Text(String(format: loc.localized("create_team.roster.count_format"), team.players.count))
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(ColorPalette.rosterBadgeText)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(ColorPalette.rosterBadgeBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            }

            VStack(spacing: 8) {
                ForEach(team.players) { player in
                    rosterRow(player: player)
                }
            }
        }
    }

    private func rosterRow(player: RosterPlayerDraft) -> some View {
        HStack(spacing: 12) {
            Text(player.initials)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(player.useFilledAvatar ? ColorPalette.rosterInitialsPrimary : ColorPalette.rosterInitialsAlternate)
                .frame(width: 32, height: 32)
                .background(player.useFilledAvatar ? ColorPalette.rosterBadgeBackground : ColorPalette.background)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(ColorPalette.formFieldStrokeBold, lineWidth: player.useFilledAvatar ? 0 : 1)
                )

            Text(displayName(for: player))
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(ColorPalette.aiCardTitle)

            Spacer(minLength: 0)
        }
        .padding(12)
        .background(ColorPalette.background)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(ColorPalette.cardBorder, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }

    private func displayName(for player: RosterPlayerDraft) -> String {
        if player.isCaptain {
            return player.name + loc.localized("create_team.roster.captain_suffix")
        }
        return player.name
    }

    private func additionalInfoSection(team: Team) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(loc.localized("create_team.field.additional"))
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(ColorPalette.squadHeading)

            Text(team.additionalInfo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                ? loc.localized("create_team.placeholder.additional")
                : team.additionalInfo)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(
                    team.additionalInfo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                        ? ColorPalette.formPlaceholder
                        : ColorPalette.squadHeading
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(ColorPalette.background)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(ColorPalette.formFieldStrokeBold, lineWidth: 2)
                )
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
        .padding(.bottom, 24)
    }

    private func actionButtons(team: Team) -> some View {
        VStack(spacing: 12) {
            Button {
                teamBeingEdited = team
            } label: {
                Text(loc.localized("team_detail.edit"))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(ColorPalette.background)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(ColorPalette.navigationBarLinearGradient)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .shadow(color: ColorPalette.shadowBlue.opacity(0.45), radius: 12, x: 0, y: 6)
            }
            .buttonStyle(.plain)

            Button {
                teamsViewModel.deleteTeam(id: teamId)
                dismiss()
            } label: {
                Text(loc.localized("team_detail.delete"))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(ColorPalette.background)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(deleteButtonGradient)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 4)
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    TeamDetailView(teamId: Team.previewLakeWalkers.id, teamsViewModel: .previewWithData)
        .environmentObject(LocalizationService.shared)
}
