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
        .onChange(of: selectedTab) { _, value in
            requestedMainTab = value.rawValue
        }
    }
}

private enum MainTab: String, Hashable {
    case home, history
}

#Preview {
    MainTabView()
}
