import SwiftUI

struct InventoryEquipmentDetailView: View {
    @EnvironmentObject private var loc: LocalizationService
    let item: InventoryItem
    var onClose: () -> Void
    var onEdit: () -> Void
    var onDelete: () -> Void

    @State private var showDeleteConfirm = false

    private var deleteGradient: LinearGradient {
        LinearGradient(
            colors: [
                ColorPalette.deleteButtonGradientStart,
                ColorPalette.deleteButtonGradientMid,
                ColorPalette.deleteButtonGradientEnd
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                AppScreenBackgroundView()

                VStack(spacing: 0) {
                    AppDetailNavigationBar(
                        topInset: geo.safeAreaInsets.top,
                        title: item.title.resolved(using: loc),
                        backButtonImageName: "InvEquipDetailBack",
                        onBack: { onClose() },
                        backButtonSize: 50,
                        bottomPadding: 24,
                        titleMinimumScaleFactor: 0.75,
                        shadowStyle: .softBlue
                    )
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 24) {
                            dateSection
                            equipmentNameSection
                            iconSection
                            statusSection
                            descriptionSection
                            editButton
                            deleteButton
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .padding(.bottom, 48)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .top)
        .alert(loc.localized("inventory.detail.delete_confirm_title"), isPresented: $showDeleteConfirm) {
            Button(loc.localized("inventory.detail.delete_cancel"), role: .cancel) {}
            Button(loc.localized("inventory.detail.delete_confirm"), role: .destructive) {
                onDelete()
            }
        } message: {
            Text(loc.localized("inventory.detail.delete_confirm_message"))
        }
    }

    private var dateSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(loc.localized("create_equipment.field.date"))
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(ColorPalette.squadHeading)

            HStack(spacing: 12) {
                Image("CreateEquipDateIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)

                Text(formattedDate(item.addedAt))
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(ColorPalette.squadHeading)

                Spacer(minLength: 0)
            }
            .padding(.leading, 14)
            .padding(.trailing, 16)
            .padding(.vertical, 14)
            .background(ColorPalette.background)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(ColorPalette.formFieldStrokeBold, lineWidth: 1)
            )
            .shadow(color: ColorPalette.shadowBlue.opacity(0.12), radius: 8, x: 0, y: 4)
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let df = DateFormatter()
        df.locale = Locale(identifier: loc.language.rawValue)
        df.dateStyle = .short
        df.timeStyle = .none
        return df.string(from: date)
    }

    private var equipmentNameSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(loc.localized("create_equipment.field.name"))
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(ColorPalette.squadHeading)

            HStack(spacing: 12) {
                Text(item.title.resolved(using: loc))
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(ColorPalette.squadHeading)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Image("CreateEquipNameIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
            .padding(.leading, 16)
            .padding(.trailing, 14)
            .padding(.vertical, 15)
            .background(ColorPalette.background)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(ColorPalette.formFieldStrokeBold, lineWidth: 1)
            )
            .shadow(color: ColorPalette.shadowBlue.opacity(0.12), radius: 8, x: 0, y: 4)
        }
    }

    private var iconSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(loc.localized("inventory.detail.field.icon"))
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(ColorPalette.squadHeading)

            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(ColorPalette.createEquipmentIconCellSelectedFill)

                Image(item.thumbImageName)
                    .resizable()
                    .interpolation(.high)
                    .scaledToFit()
                    .frame(width: 56, height: 56)
                    .padding(20)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 96)
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(ColorPalette.createEquipmentIconCellSelectedStroke, lineWidth: 2)
            )
            .padding(16)
            .background(ColorPalette.background)
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(ColorPalette.cardBorder, lineWidth: 1)
            )
        }
    }

    private var statusSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(loc.localized("create_equipment.field.status"))
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(ColorPalette.squadHeading)

            HStack(spacing: 12) {
                statusChip(isActiveOption: true, selected: item.isActive)
                statusChip(isActiveOption: false, selected: !item.isActive)
            }
        }
    }

    private func statusChip(isActiveOption: Bool, selected: Bool) -> some View {
        HStack(spacing: 12) {
            Image(selected ? "CreateEquipRadioOn" : "CreateEquipRadioOff")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)

            Text(loc.localized(isActiveOption ? "inventory.status.active" : "inventory.status.inactive"))
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(ColorPalette.squadHeading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(selected && isActiveOption ? ColorPalette.createEquipmentStatusActiveFill : ColorPalette.background)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(
                    selected ? ColorPalette.createEquipmentStatusStrokeSelected : ColorPalette.createEquipmentStatusStrokeIdle,
                    lineWidth: 2
                )
        )
    }

    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(loc.localized("create_equipment.field.description"))
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(ColorPalette.squadHeading)

            Text(item.subtitle.resolved(using: loc))
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(ColorPalette.squadHeading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(ColorPalette.background)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(ColorPalette.formFieldStrokeBold, lineWidth: 1)
                )
                .shadow(color: ColorPalette.shadowBlue.opacity(0.12), radius: 8, x: 0, y: 4)
        }
    }

    private var editButton: some View {
        Button {
            onEdit()
        } label: {
            Text(loc.localized("inventory.detail.edit"))
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(ColorPalette.background)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(ColorPalette.navigationBarLinearGradient)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .shadow(color: ColorPalette.shadowBlue.opacity(0.45), radius: 12, x: 0, y: 6)
        }
        .buttonStyle(.plain)
    }

    private var deleteButton: some View {
        Button {
            showDeleteConfirm = true
        } label: {
            Text(loc.localized("inventory.detail.delete"))
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(ColorPalette.background)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(deleteGradient)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .shadow(color: ColorPalette.shadowBlue.opacity(0.35), radius: 12, x: 0, y: 6)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    InventoryEquipmentDetailView(
        item: InventoryTabViewModel.previewWithSampleItems.items.first
            ?? InventoryItem(
                title: .literal("Preview"),
                subtitle: .literal("—"),
                isActive: true,
                addedAt: Date(),
                thumbImageName: "CreateEquipPick0",
                accentDotIndex: 0
            ),
        onClose: {},
        onEdit: {},
        onDelete: {}
    )
    .environmentObject(LocalizationService.shared)
}
