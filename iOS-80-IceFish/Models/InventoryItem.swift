import Foundation

struct InventoryItem: Identifiable, Equatable, Codable {
    let id: UUID
    let title: InventoryDisplayText
    let subtitle: InventoryDisplayText
    let isActive: Bool
    let addedAt: Date
    let thumbImageName: String
    let accentDotIndex: Int

    init(
        id: UUID = UUID(),
        title: InventoryDisplayText,
        subtitle: InventoryDisplayText,
        isActive: Bool,
        addedAt: Date,
        thumbImageName: String,
        accentDotIndex: Int
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.isActive = isActive
        self.addedAt = addedAt
        self.thumbImageName = thumbImageName
        self.accentDotIndex = accentDotIndex
    }
}
