import SwiftUI

struct AppDetailNavigationBar: View {
    @Environment(\.dismiss) private var dismiss

    let topInset: CGFloat
    let title: String
    let backButtonImageName: String

    var onBack: (() -> Void)? = nil
    var backButtonSize: CGFloat = 46
    private let topInsetExtra: CGFloat = 52
    var bottomPadding: CGFloat = 32
    var titleLetterSpacing: CGFloat? = nil
    var titleMinimumScaleFactor: CGFloat = 0.85
    var shadowStyle: ShadowStyle = .drop

    enum ShadowStyle {
        case drop
        case softBlue

        fileprivate var color: Color {
            switch self {
            case .drop: return ColorPalette.createEventNavDropShadow
            case .softBlue: return ColorPalette.shadowBlue.opacity(0.5)
            }
        }
    }

    var body: some View {
        ZStack {
            HStack {
                Button {
                    if let onBack {
                        onBack()
                    } else {
                        dismiss()
                    }
                } label: {
                    Image(backButtonImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: backButtonSize, height: backButtonSize)
                }
                .buttonStyle(.plain)

                Spacer()

                Color.clear
                    .frame(width: 44, height: 44)
            }

            titleLabel
                .padding(.horizontal, 56)
        }
        .padding(.horizontal, 24)
        .padding(.top, topInset + topInsetExtra)
        .padding(.bottom, bottomPadding)
        .background(ColorPalette.navigationBarLinearGradient)
        .shadow(color: shadowStyle.color, radius: 12, x: 0, y: 6)
    }

    private var titleLabel: some View {
        Group {
            if let titleLetterSpacing {
                Text(title)
                    .font(.system(size: 24, weight: .bold))
                    .tracking(titleLetterSpacing)
                    .foregroundColor(ColorPalette.background)
                    .lineLimit(1)
                    .minimumScaleFactor(titleMinimumScaleFactor)
            } else {
                Text(title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(ColorPalette.background)
                    .lineLimit(1)
                    .minimumScaleFactor(titleMinimumScaleFactor)
            }
        }
    }
}

#Preview {
    AppDetailNavigationBar(
        topInset: 47,
        title: "Preview",
        backButtonImageName: "CreateEventNavBack",
        titleLetterSpacing: -0.6
    )
}
