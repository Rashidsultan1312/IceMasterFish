import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var loc: LocalizationService
    @State private var showLaunchSplash = true
    @State private var showOnboarding = !OnboardingCompletionStore.shared.isCompleted
    @StateObject private var onboardingViewModel = OnboardingViewModel()

    var body: some View {
        ZStack {
            if showLaunchSplash {
                LaunchSplashView {
                    withAnimation(.easeOut(duration: 0.25)) {
                        showLaunchSplash = false
                    }
                }
            } else if showOnboarding {
                OnboardingView(viewModel: onboardingViewModel)
                    .onAppear {
                        onboardingViewModel.onFinished = {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                showOnboarding = false
                            }
                        }
                    }
            } else {
                MainTabView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(LocalizationService.shared)
}
