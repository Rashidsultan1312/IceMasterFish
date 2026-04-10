import SwiftUI

struct TeamsTabView: View {
    @EnvironmentObject private var loc: LocalizationService
    @ObservedObject var viewModel: TeamsTabViewModel
    @State private var showCreateTeam = false
    @State private var teamForDetail: Team?
    @State private var coachChatKind: AICoachChatKind?
    @State private var showAutoNameGenerator = false
    @State private var showAutoLogoGenerator = false

    private let aiBlobBlue: [Color] = [
        Color(red: 219 / 255, green: 234 / 255, blue: 254 / 255),
        Color(red: 239 / 255, green: 246 / 255, blue: 255 / 255)
    ]

    private let aiBlobPurple: [Color] = [
        Color(red: 239 / 255, green: 246 / 255, blue: 255 / 255),
        Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255),
        Color(red: 219 / 255, green: 234 / 255, blue: 254 / 255)
    ]

    private let aiBlobAmber: [Color] = [
        Color(red: 254 / 255, green: 243 / 255, blue: 199 / 255),
        Color(red: 255 / 255, green: 251 / 255, blue: 235 / 255)
    ]

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 32) {
                squadsBlock
                aiBlock
                CreateTeamBarButton {
                    showCreateTeam = true
                }
            }
            .padding(.top, 24)
            .padding(.bottom, 120)
        }
        .fullScreenCover(isPresented: $showCreateTeam) {
            CreateTeamView(onSave: { team in
                viewModel.addTeam(team)
            })
            .environmentObject(loc)
        }
        .fullScreenCover(item: $teamForDetail) { team in
            TeamDetailView(teamId: team.id, teamsViewModel: viewModel)
                .environmentObject(loc)
        }
        .fullScreenCover(item: $coachChatKind) { kind in
            AICoachChatView(kind: kind)
                .environmentObject(loc)
        }
        .fullScreenCover(isPresented: $showAutoNameGenerator) {
            AutoNameGeneratorView()
                .environmentObject(loc)
        }
        .fullScreenCover(isPresented: $showAutoLogoGenerator) {
            AutoLogoGeneratorView()
                .environmentObject(loc)
        }
    }

    private var squadsBlock: some View {
        VStack(alignment: .leading, spacing: 20) {
            TeamsSectionHeaderView(iconImageName: "SectionSquadsIcon", titleKey: "teams.section.squads")

            if viewModel.teams.isEmpty {
                TeamsEmptyStateCard()
            } else {
                VStack(spacing: 16) {
                    ForEach(viewModel.teams) { team in
                        TeamCardView(team: team)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                teamForDetail = team
                            }
                    }
                }
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(ColorPalette.teamsSectionBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var aiBlock: some View {
        VStack(alignment: .leading, spacing: 20) {
            TeamsSectionHeaderView(iconImageName: "SectionAIIcon", titleKey: "teams.section.ai")

            VStack(spacing: 16) {
                HStack(alignment: .top, spacing: 16) {
                    AIToolCardView(
                        iconImageName: "AINameIcon",
                        titleKey: "teams.ai.name.title",
                        subtitleKey: "teams.ai.name.subtitle",
                        blobGradient: aiBlobBlue,
                        action: { showAutoNameGenerator = true }
                    )
                    .frame(maxWidth: .infinity)

                    AIToolCardView(
                        iconImageName: "AILogoIcon",
                        titleKey: "teams.ai.logo.title",
                        subtitleKey: "teams.ai.logo.subtitle",
                        blobGradient: aiBlobPurple,
                        action: { showAutoLogoGenerator = true }
                    )
                    .frame(maxWidth: .infinity)
                }

                HStack(alignment: .top, spacing: 16) {
                    AIToolCardView(
                        iconImageName: "AICoachIcon",
                        titleKey: "teams.ai.coach.title",
                        subtitleKey: "teams.ai.coach.subtitle",
                        blobGradient: aiBlobBlue,
                        action: { coachChatKind = .fishing }
                    )
                    .frame(maxWidth: .infinity)

                    AIToolCardView(
                        iconImageName: "AITournamentIcon",
                        titleKey: "teams.ai.tournament.title",
                        subtitleKey: "teams.ai.tournament.subtitle",
                        blobGradient: aiBlobAmber,
                        action: { coachChatKind = .tournament }
                    )
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(ColorPalette.aiSectionBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

#Preview("Empty") {
    TeamsTabView(viewModel: TeamsTabViewModel())
        .environmentObject(LocalizationService.shared)
}

#Preview("With team") {
    TeamsTabView(viewModel: .previewWithData)
        .environmentObject(LocalizationService.shared)
}
