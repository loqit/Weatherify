import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    
    var body: some View {
        TabView {
            SearchCityView(store: Store(initialState: SearchCityReducer.State()) {
                SearchCityReducer()
                    ._printChanges()
            })
                .tabItem {
                    Image(systemName: "cloud.sun")
                    Text("Weather")
                }
            CountriesView(store: Store(initialState: CountriesReducer.State(), reducer: {
                CountriesReducer()
                    ._printChanges()
            }))
                .tabItem {
                    Image(systemName: "map")
                    Text("Countries")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        ContentView()
    }
}
