import SwiftUI

@main
struct iOS_80_IceFishApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(LocalizationService.shared)
        }
    }
}
