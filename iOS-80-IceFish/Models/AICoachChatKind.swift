import Foundation

enum AICoachChatKind: String, Identifiable, Hashable {
    case fishing
    case tournament

    var id: String { rawValue }
}
