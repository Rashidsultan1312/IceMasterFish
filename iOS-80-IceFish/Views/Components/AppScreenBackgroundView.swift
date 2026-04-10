import SwiftUI

struct AppScreenBackgroundView: View {
    private let designWidth: CGFloat = 390
    private let imageLayerWidth: CGFloat = 711
    private let imageOriginX: CGFloat = -263

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let scale = w / designWidth
            ZStack(alignment: .topLeading) {
                ColorPalette.background
                Image("AppScreenBackground")
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageLayerWidth * scale, height: h)
//                    .offset(x: imageOriginX * scale, y: 0)
            }
            .frame(width: w, height: h)
            .clipped()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    AppScreenBackgroundView()
}
