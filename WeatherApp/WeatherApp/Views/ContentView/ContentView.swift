import SwiftUI
import ComposableArchitecture

struct ContentView: View {

    // MARK: - Properties

    @State private var selectedTab: RootTab = .first

    // MARK: - Body

    var body: some View {
        TabView(selection: $selectedTab) {
            SearchCityView(store: Store(initialState: SearchCityReducer.State()) {
                SearchCityReducer()
            })
            .tabItem {
                Image(systemName: "cloud.sun")
                Text("Weather")
            }
            .tag(RootTab.first)
            CountriesView(store: Store(initialState: CountriesReducer.State()) {
                CountriesReducer()
            })
            .tabItem {
                Image(systemName: "map")
                Text("Countries")
            }
            .tag(RootTab.second)
        }
        .edgesIgnoringSafeArea(.bottom)
        .tint(.init(hex: "FEE3BC"))
    }
}
