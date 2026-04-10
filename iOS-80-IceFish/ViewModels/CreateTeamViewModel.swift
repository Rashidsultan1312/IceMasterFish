import Foundation
import UIKit
import Combine

@MainActor
final class CreateTeamViewModel: ObservableObject {
    @Published var teamName: String = ""
    @Published var leagueType: TeamLeagueType = .pro
    @Published var selectedPresetIndex: Int? = 0
    @Published var customLogoImage: UIImage?
    @Published var customLogoFileName: String = ""
    @Published var customLogoByteCount: Int = 0
    @Published var draftPlayerName: String = ""
    @Published var players: [RosterPlayerDraft] = []
    @Published var additionalInfo: String = ""

    private let presetAssetNames = (1...6).map { "CreateTeamPreset\($0)" }
    private var autosaveCancellable: AnyCancellable?

    func presetImageName(at index: Int) -> String {
        presetAssetNames[index]
    }

    func selectPreset(_ index: Int) {
        selectedPresetIndex = index
        customLogoImage = nil
        customLogoFileName = ""
        customLogoByteCount = 0
    }

    func applyPickedImage(_ image: UIImage, data: Data, fileName: String) {
        customLogoImage = image
        customLogoByteCount = data.count
        customLogoFileName = fileName.isEmpty ? "team_logo.jpg" : fileName
        selectedPresetIndex = nil
    }

    func clearCustomLogo() {
        customLogoImage = nil
        customLogoFileName = ""
        customLogoByteCount = 0
        if selectedPresetIndex == nil {
            selectedPresetIndex = 0
        }
    }

    func addPlayerFromDraft() {
        let trimmed = draftPlayerName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let isCaptain = players.isEmpty
        let useFilled = players.count % 2 == 0
        players.append(RosterPlayerDraft(name: trimmed, isCaptain: isCaptain, useFilledAvatar: useFilled))
        draftPlayerName = ""
    }

    func removePlayer(id: UUID) {
        guard let idx = players.firstIndex(where: { $0.id == id }) else { return }
        let wasCaptain = players[idx].isCaptain
        players.remove(at: idx)
        if wasCaptain, let first = players.indices.first {
            players[first].isCaptain = true
        }
    }

    func rosterCountFormat(loc: LocalizationService) -> String {
        String(format: loc.localized("create_team.roster.count_format"), players.count)
    }

    func loadFromTeam(_ team: Team) {
        teamName = team.name
        leagueType = team.leagueType
        additionalInfo = team.additionalInfo
        players = team.players
        if let data = team.customLogoData, let image = UIImage(data: data) {
            customLogoImage = image
            customLogoByteCount = data.count
            customLogoFileName = "team_logo.jpg"
            selectedPresetIndex = nil
        } else if let idx = team.presetIndex {
            selectedPresetIndex = idx
            customLogoImage = nil
            customLogoFileName = ""
            customLogoByteCount = 0
        } else {
            selectedPresetIndex = 0
            customLogoImage = nil
            customLogoFileName = ""
            customLogoByteCount = 0
        }
    }

    func makeTeam(existingId: UUID?) -> Team? {
        let trimmed = teamName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        let preset: Int?
        let customData: Data?
        if let img = customLogoImage {
            let data = img.jpegData(compressionQuality: 0.88) ?? Data()
            preset = nil
            customData = data.isEmpty ? nil : data
        } else if let idx = selectedPresetIndex {
            preset = idx
            customData = nil
        } else {
            preset = 0
            customData = nil
        }

        return Team(
            id: existingId ?? UUID(),
            name: trimmed,
            leagueType: leagueType,
            presetIndex: preset,
            customLogoData: customData,
            players: players,
            additionalInfo: additionalInfo
        )
    }

    /// Debounced persistence while editing an existing team (requires non-empty trimmed name).
    func enableAutosave(existingId: UUID, onAutosave: @escaping (Team) -> Void) {
        autosaveCancellable?.cancel()
        autosaveCancellable = $teamName.map { _ in () }
            .merge(with: $leagueType.map { _ in () })
            .merge(with: $selectedPresetIndex.map { _ in () })
            .merge(with: $customLogoImage.map { _ in () })
            .merge(with: $customLogoByteCount.map { _ in () })
            .merge(with: $players.map { _ in () })
            .merge(with: $additionalInfo.map { _ in () })
            .debounce(for: .milliseconds(400), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                guard let self, let team = self.makeTeam(existingId: existingId) else { return }
                onAutosave(team)
            }
    }

    func disableAutosave() {
        autosaveCancellable?.cancel()
        autosaveCancellable = nil
    }
}
