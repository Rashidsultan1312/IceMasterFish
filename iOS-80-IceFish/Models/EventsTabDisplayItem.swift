import Foundation

struct EventsTabDisplayItem: Identifiable, Equatable {
    let id: UUID
    let title: String
    let body: String
    let startDate: Date
    let secondaryLine: EventsTabSecondaryLine
    let showFeaturedBadge: Bool
    let showUpcomingBadge: Bool
    let listIndex: Int
}

enum EventsTabSecondaryLine: Equatable {
    case location(String)
    case members(count: Int)
}
