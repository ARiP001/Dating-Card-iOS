import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: MainTab = .home
    @AppStorage("requestedMainTab") private var requestedMainTab = MainTab.home.rawValue

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(MainTab.home)

            HistoryView()
                .tabItem {
                    Label("Session", systemImage: "clock.arrow.circlepath")
                }
                .tag(MainTab.history)
        }
        .tint(Color.accentDustyMauve)
        .onChange(of: requestedMainTab) { _, value in
            selectedTab = MainTab(rawValue: value) ?? .home
        }
    }
}

private enum MainTab: String, Hashable {
    case home, history
}

#Preview {
    MainTabView()
}
