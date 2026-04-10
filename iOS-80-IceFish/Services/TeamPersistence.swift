import Foundation

/// Loads and persists the full teams list as JSON in `UserDefaults`.
/// Mutations should go through ``TeamsTabViewModel`` (`addTeam` / `replaceTeam` / `deleteTeam`) so list and disk stay in sync.
protocol TeamStorageProtocol: AnyObject {
    func load() -> [Team]
    func save(_ teams: [Team])
}

/// UserDefaults-backed storage for ``Team``; stable key `icefish_teams_v1`.
final class UserDefaultsTeamStorage: TeamStorageProtocol {
    static let shared = UserDefaultsTeamStorage()

    private let defaults: UserDefaults
    private let key = "icefish_teams_v1"

    init(userDefaults: UserDefaults = .standard) {
        self.defaults = userDefaults
    }

    func load() -> [Team] {
        guard let data = defaults.data(forKey: key), !data.isEmpty else { return [] }
        do {
            return try JSONDecoder().decode([Team].self, from: data)
        } catch {
            #if DEBUG
            print("UserDefaultsTeamStorage: decode failed — \(error)")
            #endif
            return []
        }
    }

    func save(_ teams: [Team]) {
        do {
            let data = try JSONEncoder().encode(teams)
            defaults.set(data, forKey: key)
        } catch {
            #if DEBUG
            print("UserDefaultsTeamStorage: encode failed — not writing key (existing data preserved): \(error)")
            #endif
        }
    }
}

/// Backward-compatible name for ``UserDefaultsTeamStorage``.
typealias TeamPersistence = UserDefaultsTeamStorage
