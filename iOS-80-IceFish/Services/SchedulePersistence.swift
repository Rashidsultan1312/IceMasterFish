import Foundation

protocol ScheduleStorageProtocol: AnyObject {
    func load() -> [ScheduleEvent]
    func save(_ events: [ScheduleEvent])
}

final class UserDefaultsScheduleStorage: ScheduleStorageProtocol {
    static let shared = UserDefaultsScheduleStorage()

    private let defaults: UserDefaults
    private let key = "icefish_schedule_events_v1"

    init(userDefaults: UserDefaults = .standard) {
        self.defaults = userDefaults
    }

    func load() -> [ScheduleEvent] {
        guard let data = defaults.data(forKey: key), !data.isEmpty else { return [] }
        do {
            return try JSONDecoder().decode([ScheduleEvent].self, from: data)
        } catch {
            #if DEBUG
            print("UserDefaultsScheduleStorage: decode failed - \(error)")
            #endif
            return []
        }
    }

    func save(_ events: [ScheduleEvent]) {
        do {
            let data = try JSONEncoder().encode(events)
            defaults.set(data, forKey: key)
        } catch {
            #if DEBUG
            print("UserDefaultsScheduleStorage: encode failed - not writing key: \(error)")
            #endif
        }
    }
}

