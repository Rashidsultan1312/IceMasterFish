import Combine
import Foundation

@MainActor
final class CreateEquipmentViewModel: ObservableObject {
    @Published var pickedDate: Date = Date()
    @Published var equipmentName: String = ""
    @Published var selectedThumbIndex: Int = 0
    @Published var statusIsActive: Bool = true
    @Published var shortDescription: String = ""
    private(set) var editingItemId: UUID?

    /// 3×3 picker icons exported from Figma (`13:2226` / `13:2228`).
    static let pickIconImageNames: [String] = (0 ... 8).map { "CreateEquipPick\($0)" }

    var canSubmit: Bool {
        !equipmentName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func reset() {
        editingItemId = nil
        pickedDate = Date()
        equipmentName = ""
        selectedThumbIndex = 0
        statusIsActive = true
        shortDescription = ""
    }

    func apply(from item: InventoryItem, loc: LocalizationService) {
        editingItemId = item.id
        pickedDate = item.addedAt
        equipmentName = item.title.resolved(using: loc)
        let resolvedSubtitle = item.subtitle.resolved(using: loc)
        let emptySubtitle = loc.localized("create_equipment.subtitle_empty")
        shortDescription = resolvedSubtitle == emptySubtitle ? "" : resolvedSubtitle
        statusIsActive = item.isActive
        selectedThumbIndex = Self.thumbIndex(for: item.thumbImageName)
    }

    static func thumbIndex(for thumbImageName: String) -> Int {
        if let idx = pickIconImageNames.firstIndex(of: thumbImageName) {
            return idx
        }
        let prefix = "InvThumb"
        if thumbImageName.hasPrefix(prefix),
           let n = Int(thumbImageName.dropFirst(prefix.count)) {
            return min(max(n, 0), pickIconImageNames.count - 1)
        }
        return 0
    }

    func buildItem() -> InventoryItem? {
        let name = equipmentName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return nil }

        let detail = shortDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        let subtitle: InventoryDisplayText = detail.isEmpty
            ? .localized(key: "create_equipment.subtitle_empty")
            : .literal(detail)

        let thumb = Self.pickIconImageNames[selectedThumbIndex % Self.pickIconImageNames.count]

        return InventoryItem(
            id: editingItemId ?? UUID(),
            title: .literal(name),
            subtitle: subtitle,
            isActive: statusIsActive,
            addedAt: pickedDate,
            thumbImageName: thumb,
            accentDotIndex: selectedThumbIndex % 6
        )
    }
}
