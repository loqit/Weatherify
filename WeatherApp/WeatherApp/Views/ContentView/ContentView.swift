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
/// Temporarly hide this overlay
//        .overlay(alignment: .bottom) {
//            let color = selectedTab.selectedColor
//            GeometryReader { proxy in
//                let part = proxy.size.width / CGFloat(RootTab.allCases.count)
//                VStack {
//                    Spacer()
//                    Circle()
//                        .foregroundColor(.clear)
//                        .background(color.blur(radius: 20))
//                        .frame(width: part, height: 30)
//                        .shadow(color: color, radius: 40)
//                        .offset(x: CGFloat(selectedTab.rawValue) * part,
//                                y: 30)
//                }
//            }
//        }
        .edgesIgnoringSafeArea(.bottom)
    }
}
