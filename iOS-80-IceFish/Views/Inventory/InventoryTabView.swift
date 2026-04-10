import SwiftUI

struct InventoryTabView: View {
    @EnvironmentObject private var loc: LocalizationService
    @ObservedObject var viewModel: InventoryTabViewModel
    @State private var inventoryRoute: InventoryRoute?

    private enum InventoryRoute: Identifiable, Equatable {
        case detail(InventoryItem)
        case create
        case edit(InventoryItem)

        var id: String {
            switch self {
            case .detail(let item): return "d-\(item.id.uuidString)"
            case .create: return "create"
            case .edit(let item): return "e-\(item.id.uuidString)"
            }
        }
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 32) {
                summaryStrip
                myEquipmentSection
                addInventoryButton
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 120)
        }
        .background(AppScreenBackgroundView())
        .fullScreenCover(item: $inventoryRoute) { route in
            Group {
                switch route {
                case .detail(let item):
                    InventoryEquipmentDetailView(
                        item: item,
                        onClose: { inventoryRoute = nil },
                        onEdit: { inventoryRoute = .edit(item) },
                        onDelete: {
                            viewModel.removeItem(id: item.id)
                            inventoryRoute = nil
                        }
                    )
                case .create:
                    CreateEquipmentView { newItem in
                        viewModel.addItem(newItem)
                        inventoryRoute = nil
                    }
                case .edit(let item):
                    CreateEquipmentView(existingItem: item) { updated in
                        viewModel.replaceItem(updated)
                        inventoryRoute = nil
                    }
                    .id(item.id)
                }
            }
            .environmentObject(loc)
        }
    }

    private var summaryStrip: some View {
        HStack(alignment: .top, spacing: 10) {
            statCard(
                iconName: "InvStatTotal",
                value: viewModel.totalCount,
                titleKey: "inventory.stat.total"
            )
            statCard(
                iconName: "InvStatActive",
                value: viewModel.activeCount,
                titleKey: "inventory.stat.active"
            )
            statCard(
                iconName: "InvStatInactive",
                value: viewModel.inactiveCount,
                titleKey: "inventory.stat.inactive"
            )
        }
    }

    private func statCard(iconName: String, value: Int, titleKey: String) -> some View {
        VStack(spacing: 10) {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(height: 40)

            Text("\(value)")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(ColorPalette.inventoryStatNumber)

            Text(loc.localized(titleKey))
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(ColorPalette.textSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .padding(.horizontal, 6)
        .background(ColorPalette.background)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(ColorPalette.cardBorder, lineWidth: 1)
        )
    }

    private var myEquipmentSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image("InvSectionEquipment")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)

                Text(loc.localized("inventory.section.my_equipment"))
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(ColorPalette.autoNameSectionLabel)
            }

            if viewModel.items.isEmpty {
                emptyEquipmentCard
            } else {
                VStack(spacing: 16) {
                    ForEach(viewModel.items) { item in
                        Button {
                            inventoryRoute = .detail(item)
                        } label: {
                            InventoryEquipmentRowView(item: item)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private var emptyEquipmentCard: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(ColorPalette.background)

            RoundedRectangle(cornerRadius: 999, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            ColorPalette.teamCardGradientBlob,
                            ColorPalette.cardBorder.opacity(0.95)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 128, height: 128)
                .opacity(0.5)
                .offset(x: 200, y: 4)
                .allowsHitTesting(false)

            RoundedRectangle(cornerRadius: 999, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            ColorPalette.mainBackgroundTop.opacity(0.9),
                            ColorPalette.background
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 96, height: 96)
                .opacity(0.5)
                .offset(x: -20, y: 140)
                .allowsHitTesting(false)

            VStack(spacing: 0) {
                Image("InvEmptyState")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 200)
                    .padding(.bottom, 16)

                Text(loc.localized("inventory.empty.title"))
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(ColorPalette.autoNameSectionLabel)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 8)

                Text(loc.localized("inventory.empty.message"))
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(ColorPalette.inventoryEmptyBodyText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 12)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 28)
            .padding(.horizontal, 16)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(ColorPalette.cardBorder, lineWidth: 1)
        )
    }

    private var addInventoryButton: some View {
        Button {
            inventoryRoute = .create
        } label: {
            HStack(spacing: 8) {
                Image("InvAddInventory")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text(loc.localized("inventory.add_button"))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(ColorPalette.background)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [
                        ColorPalette.navigationBarGradientStart,
                        ColorPalette.navigationBarGradientMid,
                        ColorPalette.navigationBarGradientEnd
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(color: ColorPalette.shadowBlue.opacity(0.45), radius: 12, x: 0, y: 6)
        }
        .buttonStyle(.plain)
    }
}

#Preview("Empty") {
    InventoryTabView(viewModel: .previewEmpty)
        .environmentObject(LocalizationService.shared)
}

#Preview("With items") {
    InventoryTabView(viewModel: .previewWithSampleItems)
        .environmentObject(LocalizationService.shared)
}
