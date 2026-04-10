import SwiftUI

struct CreateEquipmentView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var loc: LocalizationService
    @StateObject private var form = CreateEquipmentViewModel()
    @State private var showDatePicker = false

    var existingItem: InventoryItem? = nil
    var onSave: ((InventoryItem) -> Void)?

    private var isEditMode: Bool { existingItem != nil }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                AppScreenBackgroundView()

                VStack(spacing: 0) {
                    AppDetailNavigationBar(
                        topInset: geo.safeAreaInsets.top,
                        title: loc.localized(isEditMode ? "create_equipment.title_edit" : "create_equipment.nav_title"),
                        backButtonImageName: "CreateEquipBack",
                        backButtonSize: 50,
                        bottomPadding: 24,
                        shadowStyle: .softBlue
                    )
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 32) {
                            dateSection
                            equipmentNameSection
                            selectIconSection
                            statusSection
                            descriptionSection
                            submitButton
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 32)
                        .padding(.bottom, 48)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .top)
        .onAppear {
            if let existingItem {
                form.apply(from: existingItem, loc: loc)
            } else {
                form.reset()
            }
        }
        .sheet(isPresented: $showDatePicker) {
            NavigationStack {
                DatePicker(
                    "",
                    selection: $form.pickedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .padding()
                .navigationTitle(loc.localized("create_equipment.field.date"))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button(loc.localized("create_equipment.date_done")) {
                            showDatePicker = false
                        }
                    }
                }
            }
            .presentationDetents([.medium, .large])
            .environmentObject(loc)
        }
    }

    private var dateSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(loc.localized("create_equipment.field.date"))
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(ColorPalette.squadHeading)

            Button {
                showDatePicker = true
            } label: {
                HStack(spacing: 12) {
                    Image("CreateEquipDateIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)

                    Text(formattedPickedDate)
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
            .buttonStyle(.plain)
        }
    }

    private var formattedPickedDate: String {
        let df = DateFormatter()
        df.locale = Locale(identifier: loc.language.rawValue)
        df.dateStyle = .short
        df.timeStyle = .none
        return df.string(from: form.pickedDate)
    }

    private var equipmentNameSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(loc.localized("create_equipment.field.name"))
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(ColorPalette.squadHeading)

            HStack(spacing: 12) {
                TextField(
                    "",
                    text: $form.equipmentName,
                    prompt: Text(loc.localized("create_equipment.placeholder.name"))
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(ColorPalette.formPlaceholder)
                )
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(ColorPalette.squadHeading)

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

    private var selectIconSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(loc.localized("create_equipment.field.select_icon"))
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(ColorPalette.squadHeading)

            VStack(spacing: 12) {
                ForEach(0 ..< 3, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(0 ..< 3, id: \.self) { col in
                            let index = row * 3 + col
                            iconCell(index: index)
                        }
                    }
                }
            }
            .padding(16)
            .background(ColorPalette.background)
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(ColorPalette.cardBorder, lineWidth: 1)
            )
        }
    }

    private func iconCell(index: Int) -> some View {
        let selected = form.selectedThumbIndex == index
        let imageName = CreateEquipmentViewModel.pickIconImageNames[index]
        return Button {
            form.selectedThumbIndex = index
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(selected ? ColorPalette.createEquipmentIconCellSelectedFill : ColorPalette.createEquipmentIconCellIdleFill)

                Image(imageName)
                    .resizable()
                    .scaledToFit()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(
                        selected ? ColorPalette.createEquipmentIconCellSelectedStroke : ColorPalette.createEquipmentIconCellIdleStroke,
                        lineWidth: 2
                    )
            )
        }
        .buttonStyle(.plain)
    }

    private var statusSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(loc.localized("create_equipment.field.status"))
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(ColorPalette.squadHeading)

            HStack(spacing: 12) {
                statusOption(isActiveOption: true)
                statusOption(isActiveOption: false)
            }
        }
    }

    private func statusOption(isActiveOption: Bool) -> some View {
        let selected = form.statusIsActive == isActiveOption
        return Button {
            form.statusIsActive = isActiveOption
        } label: {
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
        .buttonStyle(.plain)
    }

    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(loc.localized("create_equipment.field.description"))
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(ColorPalette.squadHeading)

            ZStack(alignment: .topLeading) {
                if form.shortDescription.isEmpty {
                    Text(loc.localized("create_equipment.placeholder.description"))
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(ColorPalette.formPlaceholder)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 18)
                }

                TextEditor(text: $form.shortDescription)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(ColorPalette.squadHeading)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 120)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
            }
            .background(ColorPalette.background)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(ColorPalette.formFieldStrokeBold, lineWidth: 1)
            )
            .shadow(color: ColorPalette.shadowBlue.opacity(0.12), radius: 8, x: 0, y: 4)
        }
    }

    private var submitButton: some View {
        Button {
            guard let item = form.buildItem() else { return }
            onSave?(item)
            dismiss()
        } label: {
            HStack(spacing: 8) {
                Image("CreateEquipSubmitIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text(loc.localized(isEditMode ? "create_equipment.submit_save" : "create_equipment.submit"))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(ColorPalette.background)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(ColorPalette.navigationBarLinearGradient)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(color: ColorPalette.shadowBlue.opacity(0.45), radius: 12, x: 0, y: 6)
        }
        .buttonStyle(.plain)
        .opacity(form.canSubmit ? 1 : 0.45)
        .disabled(!form.canSubmit)
    }
}

#Preview("Create") {
    CreateEquipmentView(existingItem: nil) { _ in }
        .environmentObject(LocalizationService.shared)
}

#Preview("Edit") {
    CreateEquipmentView(
        existingItem: InventoryTabViewModel.previewWithSampleItems.items.first,
        onSave: { _ in }
    )
    .environmentObject(LocalizationService.shared)
}
