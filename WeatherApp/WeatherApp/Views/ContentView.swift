import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Image(systemName: "cloud.sun")
                    Text("Weather")
                }
            CountriesView()
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
