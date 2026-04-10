import Foundation

struct Team: Identifiable, Equatable, Codable {
    let id: UUID
    var name: String
    var leagueType: TeamLeagueType
    /// Preset index 0...5 when using a bundled preset; `nil` when a custom logo is stored.
    var presetIndex: Int?
    var customLogoData: Data?
    var players: [RosterPlayerDraft]
    var additionalInfo: String

    init(
        id: UUID = UUID(),
        name: String,
        leagueType: TeamLeagueType,
        presetIndex: Int?,
        customLogoData: Data?,
        players: [RosterPlayerDraft],
        additionalInfo: String
    ) {
        self.id = id
        self.name = name
        self.leagueType = leagueType
        self.presetIndex = presetIndex
        self.customLogoData = customLogoData
        self.players = players
        self.additionalInfo = additionalInfo
    }

    func presetImageAssetName() -> String? {
        guard let index = presetIndex else { return nil }
        return "CreateTeamPreset\(index + 1)"
    }

    static let previewLakeWalkers = Team(
        name: "Lake Walkers",
        leagueType: .amateur,
        presetIndex: 0,
        customLogoData: nil,
        players: [
            RosterPlayerDraft(name: "John Doe", isCaptain: true, useFilledAvatar: true),
            RosterPlayerDraft(name: "Mike Smith", isCaptain: false, useFilledAvatar: false)
        ],
        additionalInfo: "Home lake, team motto, or any other details..."
    )
}
