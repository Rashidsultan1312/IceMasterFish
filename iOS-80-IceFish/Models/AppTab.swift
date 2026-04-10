import Foundation

enum AppTab: Int, CaseIterable, Identifiable {
    case teams
    case schedule
    case inventory
    case events
    case learn

    var id: Int { rawValue }

    var titleLocalizationKey: String {
        switch self {
        case .teams: return "tab.title.teams"
        case .schedule: return "tab.title.schedule"
        case .inventory: return "tab.title.inventory"
        case .events: return "tab.title.events"
        case .learn: return "tab.title.learn"
        }
    }

    var shortLabelKey: String {
        switch self {
        case .teams: return "tab.label.teams"
        case .schedule: return "tab.label.schedule"
        case .inventory: return "tab.label.inventory"
        case .events: return "tab.label.events"
        case .learn: return "tab.label.learn"
        }
    }

    var iconAssetName: String {
        switch self {
        case .teams: return "TabTeamsIcon"
        case .schedule: return "TabScheduleIcon"
        case .inventory: return "TabInventoryIcon"
        case .events: return "TabEventsIcon"
        case .learn: return "TabLearnIcon"
        }
    }

    var headerTitleIconAssetName: String {
        switch self {
        case .schedule: return "NavTitleSchedule"
        case .inventory: return "NavTitleInventory"
        case .events: return "NavTitleEvents"
        case .learn: return "NavTitleLearn"
        case .teams: return "NavTitleDecor"
        }
    }
}
