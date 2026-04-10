import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: AppTab = .teams
    @State private var showSettings = false
    @StateObject private var teamsViewModel = TeamsTabViewModel()
    @StateObject private var scheduleViewModel = ScheduleTabViewModel()
    @StateObject private var inventoryViewModel = InventoryTabViewModel()
    @StateObject private var eventsViewModel = EventsTabViewModel()
    @StateObject private var learnViewModel = LearnTabViewModel()

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    AppHeaderView(
                        titleKey: selectedTab.titleLocalizationKey,
                        titleIconAssetName: selectedTab.headerTitleIconAssetName,
                        safeAreaTop: geo.safeAreaInsets.top,
                        onSettings: { showSettings = true }
                    )

                    Group {
                        switch selectedTab {
                        case .teams:
                            TeamsTabView(viewModel: teamsViewModel)
                        case .schedule:
                            ScheduleTabView(viewModel: scheduleViewModel, teams: teamsViewModel.teams)
                        case .inventory:
                            InventoryTabView(viewModel: inventoryViewModel)
                        case .events:
                            EventsTabView(
                                viewModel: eventsViewModel,
                                scheduleViewModel: scheduleViewModel,
                                teams: teamsViewModel.teams
                            )
                        case .learn:
                            LearnTabView(viewModel: learnViewModel)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .background {
                    AppScreenBackgroundView()
                }
                .ignoresSafeArea(edges: .top)

                FloatingTabBar(selectedTab: $selectedTab)
                    .padding(.horizontal, 16)
                    .padding(.bottom, max(geo.safeAreaInsets.bottom, 12))
            }
            .fullScreenCover(isPresented: $showSettings) {
                SettingsView()
                    .environmentObject(LocalizationService.shared)
            }
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(LocalizationService.shared)
}
