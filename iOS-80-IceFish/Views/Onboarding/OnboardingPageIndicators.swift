import SwiftUI

struct OnboardingPageIndicators: View {
    let activeIndex: Int
    private let count = 3

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<count, id: \.self) { index in
                if index == activeIndex {
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [
                                    ColorPalette.indicatorGradientStart,
                                    ColorPalette.indicatorGradientEnd
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: 35.19, height: 10)
                } else {
                    Circle()
                        .fill(ColorPalette.inactiveDot)
                        .frame(width: 10, height: 10)
                }
            }
        }
    }
}

#Preview {
    OnboardingPageIndicators(activeIndex: 1)
        .padding()
}
