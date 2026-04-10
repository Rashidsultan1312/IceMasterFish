import Foundation
import Combine

/// Single source of truth for squads: in-memory `teams` + `UserDefaults` via ``TeamStorageProtocol``.
///
/// **UI data flow:** `MainTabView` owns one ``TeamsTabViewModel`` and passes it into ``TeamsTabView``.
/// - New team: ``TeamsTabView`` presents ``CreateTeamView`` → `onSave` → ``addTeam(_:)``.
/// - Detail: ``TeamDetailView`` resolves the row by `teamId` from `teams` (live updates when `teams` changes).
/// - Edit: detail presents ``CreateTeamView`` with `existingTeam` → `onSave` / optional `onAutosave` → ``replaceTeam(_:)``.
/// - Delete: ``deleteTeam(id:)`` then dismiss detail.
@MainActor
final class TeamsTabViewModel: ObservableObject {
    @Published private(set) var teams: [Team]

    private let storage: any TeamStorageProtocol

    init(storage: any TeamStorageProtocol = UserDefaultsTeamStorage.shared) {
        self.storage = storage
        self.teams = storage.load()
    }

    init(previewTeams teams: [Team], storage: any TeamStorageProtocol = UserDefaultsTeamStorage.shared) {
        self.storage = storage
        self.teams = teams
    }

    func addTeam(_ team: Team) {
        teams.append(team)
        persist()
    }

    func replaceTeam(_ team: Team) {
        guard let index = teams.firstIndex(where: { $0.id == team.id }) else { return }
        teams[index] = team
        persist()
    }

    func deleteTeam(id: UUID) {
        teams.removeAll { $0.id == id }
        persist()
    }

    private func persist() {
        storage.save(teams)
    }

    static var previewWithData: TeamsTabViewModel {
        TeamsTabViewModel(previewTeams: [.previewLakeWalkers])
    }
}
