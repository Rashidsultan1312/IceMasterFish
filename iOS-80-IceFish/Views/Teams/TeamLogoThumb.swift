import SwiftUI
import UIKit

struct TeamLogoThumb: View {
    let team: Team

    var body: some View {
        Group {
            if let data = team.customLogoData, let ui = UIImage(data: data) {
                Image(uiImage: ui)
                    .resizable()
                    .scaledToFill()
            } else if let asset = team.presetImageAssetName() {
                Image(asset)
                    .resizable()
                    .scaledToFit()
                    .padding(6)
                    .background(ColorPalette.presetSelectedFill)
            } else {
                ColorPalette.presetSelectedFill
            }
        }
    }
}
