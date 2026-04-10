import Foundation

enum TeamLeagueType: String, CaseIterable, Identifiable, Codable {
    case pro
    case amateur

    var id: String { rawValue }

    var localizationKey: String {
        switch self {
        case .pro: return "create_team.league.pro"
        case .amateur: return "create_team.league.amateur"
        }
    }
}
