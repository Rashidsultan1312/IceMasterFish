import SwiftUI

/// Splash from Figma node 57-639 ([80 Ice](https://www.figma.com/design/8bqiM03boHdLHRH6zNkrUL/80-Ice?node-id=57-639)); ~3s then `onFinished`.
struct LaunchSplashView: View {
    @EnvironmentObject private var loc: LocalizationService

    private let logoCardSize = CGSize(width: 159, height: 160)
    private let logoCornerRadius: CGFloat = 24

    var onFinished: () -> Void

    var body: some View {
        GeometryReader { geo in
            ZStack {
                splashGradient
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: max(geo.safeAreaInsets.top + 120, 160))

                    logoCard

                    Text(loc.localized("launch.splash.welcome"))
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                        .lineSpacing(2)
                        .padding(.horizontal, 32)
                        .padding(.top, 28)

                    Spacer(minLength: 0)

                    spinningLoader
                        .padding(.bottom, max(geo.safeAreaInsets.bottom + 36, 48))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .task {
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            onFinished()
        }
    }

    private var splashGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 29 / 255, green: 78 / 255, blue: 216 / 255),
                Color(red: 37 / 255, green: 99 / 255, blue: 235 / 255),
                Color(red: 14 / 255, green: 165 / 255, blue: 233 / 255)
            ],
            startPoint: UnitPoint(x: 0.12, y: 0.88),
            endPoint: UnitPoint(x: 0.88, y: 0.12)
        )
    }

    private var logoCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: logoCornerRadius, style: .continuous)
                .fill(Color.white)
                .frame(width: logoCardSize.width, height: logoCardSize.height)

            Image("LaunchScreenLogo")
                .resizable()
                .scaledToFill()
                .frame(width: logoCardSize.width - 2, height: logoCardSize.height - 10)
                .clipShape(RoundedRectangle(cornerRadius: logoCornerRadius - 2, style: .continuous))
        }
        .shadow(color: Color.black.opacity(0.12), radius: 16, x: 0, y: 8)
    }

    private var spinningLoader: some View {
        TimelineView(.animation(minimumInterval: 1 / 60)) { context in
            let t = context.date.timeIntervalSinceReferenceDate
            let degrees = (t * 220).truncatingRemainder(dividingBy: 360)
            Image("LaunchScreenLoader")
                .resizable()
                .interpolation(.high)
                .scaledToFit()
                .frame(width: 24, height: 24)
                .rotationEffect(.degrees(degrees))
        }
    }
}

#Preview {
    LaunchSplashView {}
        .environmentObject(LocalizationService.shared)
}
