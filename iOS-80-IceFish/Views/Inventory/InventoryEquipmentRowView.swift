import SwiftUI

struct InventoryEquipmentRowView: View {
    @EnvironmentObject private var loc: LocalizationService
    let item: InventoryItem

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(item.thumbImageName)
                .resizable()
                .scaledToFill()
                .frame(width: 66, height: 66)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .center, spacing: 8) {
                    Text(item.title.resolved(using: loc))
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(item.isActive ? ColorPalette.inventoryItemTitleActive : ColorPalette.inventoryItemTitleInactive)
                        .lineLimit(1)

                    Spacer(minLength: 8)

                    statusPill
                }

                Text(item.subtitle.resolved(using: loc))
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(
                        item.isActive ? ColorPalette.inventoryItemSubtitleActive : ColorPalette.inventoryItemSubtitleInactive
                    )
                    .lineLimit(2)

                HStack(spacing: 6) {
                    Image("InvItemCalendar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 14, height: 14)

                    Text(addedLine)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(
                            item.isActive ? ColorPalette.inventoryDateRowActive : ColorPalette.inventoryDateRowInactive
                        )
                }
            }

            Spacer(minLength: 0)

            trailingAccent
        }
        .padding(14)
        .background(ColorPalette.background)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(
                    item.isActive ? ColorPalette.inventoryItemCardStrokeActive : ColorPalette.inventoryItemCardStrokeInactive,
                    lineWidth: 1
                )
        )
        .opacity(item.isActive ? 1 : 0.7)
    }

    private var statusPill: some View {
        Text(loc.localized(item.isActive ? "inventory.status.active" : "inventory.status.inactive"))
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(item.isActive ? ColorPalette.inventoryActivePillText : ColorPalette.inventoryInactivePillText)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(
                Capsule(style: .continuous)
                    .fill(item.isActive ? ColorPalette.inventoryActivePillFill : ColorPalette.inventoryInactivePillFill)
            )
            .overlay(
                Capsule(style: .continuous)
                    .stroke(
                        item.isActive ? ColorPalette.inventoryActivePillStroke : ColorPalette.inventoryInactivePillStroke,
                        lineWidth: 1
                    )
            )
    }

    private var addedLine: String {
        let df = DateFormatter()
        df.locale = Locale(identifier: loc.language.rawValue)
        df.setLocalizedDateFormatFromTemplate("MMM d, yyyy")
        return String(format: loc.localized("inventory.added_format"), df.string(from: item.addedAt))
    }

    private var trailingAccent: some View {
        Circle()
            .fill(
                LinearGradient(
                    colors: accentColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 10, height: 10)
            .padding(.top, 4)
    }

    private var accentColors: [Color] {
        if item.isActive {
            return ColorPalette.inventoryRowAccentPair(for: item.accentDotIndex)
        }
        return ColorPalette.inventoryRowAccentPairInactive
    }
}
