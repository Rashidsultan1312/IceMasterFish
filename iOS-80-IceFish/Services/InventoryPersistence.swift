import Foundation

protocol InventoryStorageProtocol: AnyObject {
    func load() -> [InventoryItem]
    func save(_ items: [InventoryItem])
}

final class UserDefaultsInventoryStorage: InventoryStorageProtocol {
    static let shared = UserDefaultsInventoryStorage()

    private let defaults: UserDefaults
    private let key = "icefish_inventory_items_v1"

    init(userDefaults: UserDefaults = .standard) {
        self.defaults = userDefaults
    }

    func load() -> [InventoryItem] {
        guard let data = defaults.data(forKey: key), !data.isEmpty else { return [] }
        do {
            return try JSONDecoder().decode([InventoryItem].self, from: data)
        } catch {
            #if DEBUG
            print("UserDefaultsInventoryStorage: decode failed - \(error)")
            #endif
            return []
        }
    }

    func save(_ items: [InventoryItem]) {
        do {
            let data = try JSONEncoder().encode(items)
            defaults.set(data, forKey: key)
        } catch {
            #if DEBUG
            print("UserDefaultsInventoryStorage: encode failed - not writing key: \(error)")
            #endif
        }
    }
}

