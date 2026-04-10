import SwiftUI

struct CreateTeamBarButton: View {
    @EnvironmentObject private var loc: LocalizationService
    var action: () -> Void = {}

    private var barGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 30 / 255, green: 64 / 255, blue: 175 / 255),
                Color(red: 37 / 255, green: 99 / 255, blue: 235 / 255),
                Color(red: 59 / 255, green: 130 / 255, blue: 246 / 255)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image("CreateTeamPlus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text(loc.localized("teams.create.button"))
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(ColorPalette.background)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(barGradient)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(color: ColorPalette.shadowBlue.opacity(0.45), radius: 10, x: 0, y: 5)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CreateTeamBarButton()
        .environmentObject(LocalizationService.shared)
        .padding()
}
