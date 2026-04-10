import Foundation
import Combine

@MainActor
final class InventoryTabViewModel: ObservableObject {
    @Published private(set) var items: [InventoryItem]
    private let storage: any InventoryStorageProtocol

    init(
        items: [InventoryItem]? = nil,
        storage: any InventoryStorageProtocol = UserDefaultsInventoryStorage.shared
    ) {
        self.storage = storage
        self.items = items ?? storage.load()
    }

    var totalCount: Int { items.count }
    var activeCount: Int { items.filter(\.isActive).count }
    var inactiveCount: Int { items.filter { !$0.isActive }.count }

    func addItem(_ item: InventoryItem) {
        items.insert(item, at: 0)
        persist()
    }

    func replaceItem(_ item: InventoryItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index] = item
        persist()
    }

    func removeItem(id: UUID) {
        items.removeAll { $0.id == id }
        persist()
    }

    private func persist() {
        storage.save(items)
    }
}

extension InventoryTabViewModel {
    static let previewEmpty = InventoryTabViewModel(items: [])

    static let previewWithSampleItems: InventoryTabViewModel = {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(secondsFromGMT: 0)!

        func d(_ y: Int, _ m: Int, _ day: Int) -> Date {
            cal.date(from: DateComponents(year: y, month: m, day: day)) ?? Date()
        }

        let samples: [InventoryItem] = [
            InventoryItem(
                title: .localized(key: "inventory.sample.ice_auger.title"),
                subtitle: .localized(key: "inventory.sample.ice_auger.subtitle"),
                isActive: true,
                addedAt: d(2025, 1, 12),
                thumbImageName: "InvThumb0",
                accentDotIndex: 0
            ),
            InventoryItem(
                title: .localized(key: "inventory.sample.ice_rod_set.title"),
                subtitle: .localized(key: "inventory.sample.ice_rod_set.subtitle"),
                isActive: true,
                addedAt: d(2024, 11, 5),
                thumbImageName: "InvThumb1",
                accentDotIndex: 1
            ),
            InventoryItem(
                title: .localized(key: "inventory.sample.tackle_box.title"),
                subtitle: .localized(key: "inventory.sample.tackle_box.subtitle"),
                isActive: true,
                addedAt: d(2024, 10, 20),
                thumbImageName: "InvThumb2",
                accentDotIndex: 2
            ),
            InventoryItem(
                title: .localized(key: "inventory.sample.ice_shelter.title"),
                subtitle: .localized(key: "inventory.sample.ice_shelter.subtitle"),
                isActive: true,
                addedAt: d(2024, 9, 3),
                thumbImageName: "InvThumb3",
                accentDotIndex: 3
            ),
            InventoryItem(
                title: .localized(key: "inventory.sample.fish_finder.title"),
                subtitle: .localized(key: "inventory.sample.fish_finder.subtitle"),
                isActive: false,
                addedAt: d(2024, 8, 15),
                thumbImageName: "InvThumb4",
                accentDotIndex: 4
            ),
            InventoryItem(
                title: .localized(key: "inventory.sample.thermal_suit.title"),
                subtitle: .localized(key: "inventory.sample.thermal_suit.subtitle"),
                isActive: true,
                addedAt: d(2024, 12, 1),
                thumbImageName: "InvThumb5",
                accentDotIndex: 5
            ),
            InventoryItem(
                title: .localized(key: "inventory.sample.tip_up_set.title"),
                subtitle: .localized(key: "inventory.sample.tip_up_set.subtitle"),
                isActive: false,
                addedAt: d(2024, 7, 22),
                thumbImageName: "InvThumb2",
                accentDotIndex: 0
            ),
            InventoryItem(
                title: .localized(key: "inventory.sample.bait_bucket.title"),
                subtitle: .localized(key: "inventory.sample.bait_bucket.subtitle"),
                isActive: true,
                addedAt: d(2025, 2, 2),
                thumbImageName: "InvThumb0",
                accentDotIndex: 1
            )
        ]
        return InventoryTabViewModel(items: samples)
    }()
}
