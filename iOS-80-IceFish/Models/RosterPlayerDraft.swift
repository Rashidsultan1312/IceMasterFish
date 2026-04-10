import Foundation

struct RosterPlayerDraft: Identifiable, Equatable, Codable {
    let id: UUID
    var name: String
    var isCaptain: Bool
    var useFilledAvatar: Bool

    init(id: UUID = UUID(), name: String, isCaptain: Bool, useFilledAvatar: Bool) {
        self.id = id
        self.name = name
        self.isCaptain = isCaptain
        self.useFilledAvatar = useFilledAvatar
    }

    var initials: String {
        let parts = name.split(separator: " ").filter { !$0.isEmpty }
        guard let first = parts.first else { return "" }
        let a = String(first.prefix(1)).uppercased()
        if parts.count > 1, let last = parts.last {
            let b = String(last.prefix(1)).uppercased()
            return a + b
        }
        if first.count > 1 {
            return String(first.prefix(2)).uppercased()
        }
        return a
    }
}
