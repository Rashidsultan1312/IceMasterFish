import PhotosUI
import SwiftUI
import UIKit

/// Shared “event cover” picker for ``CreateEventView`` and ``EventsCreateEventView`` (PhotosPicker + app icon assets).
struct EventCreateCoverPhotoBlock: View {
    @EnvironmentObject private var loc: LocalizationService
    @ObservedObject var viewModel: CreateEventViewModel
    @Binding var photoPickerItem: PhotosPickerItem?

    private let previewHeight: CGFloat = 160

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(loc.localized("create_event.field.event_photo"))
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(ColorPalette.autoNameSectionLabel)

            ZStack(alignment: .topTrailing) {
                PhotosPicker(selection: $photoPickerItem, matching: .images) {
                    Group {
                        if let ui = viewModel.coverPreviewUIImage {
                            Image(uiImage: ui)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: previewHeight)
                                .clipped()
                        } else {
                            VStack(spacing: 8) {
                                Image("CreateTeamUploadIcon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 28, height: 28)
                                Text(loc.localized("create_team.upload.label"))
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(ColorPalette.leagueInactiveText)
                                Text(loc.localized("create_event.cover.optional"))
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(ColorPalette.textMuted)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: previewHeight)
                        }
                    }
                    .background(ColorPalette.background)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(ColorPalette.createEventFormFieldStroke, lineWidth: 1)
                    )
                    .shadow(color: ColorPalette.createEventFormFieldShadow, radius: 2, x: 0, y: 1)
                }
                .buttonStyle(.plain)

                if viewModel.coverPreviewUIImage != nil {
                    Button {
                        viewModel.clearCoverImage()
                        photoPickerItem = nil
                    } label: {
                        Image("CreateTeamRemoveUpload")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .padding(8)
                            .background(ColorPalette.removeBadgeRed)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                            )
                    }
                    .buttonStyle(.plain)
                    .padding(8)
                }
            }
        }
        .onChange(of: photoPickerItem) { newItem in
            Task {
                guard let newItem else { return }
                if let data = try? await newItem.loadTransferable(type: Data.self) {
                    await MainActor.run {
                        viewModel.applyPickedCoverImage(data: data)
                    }
                }
            }
        }
    }
}
