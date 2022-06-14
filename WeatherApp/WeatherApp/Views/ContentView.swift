import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: CitiesViewModel = CitiesViewModel()
    @State private var showCityWeatherView = false

    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(viewModel.cities) { city in
                    NavigationLink(destination: CityWeatherView(cityElement: city)) {
                        CityCard(cityInfo: city)
                    }
                    .foregroundColor(.black)
                }
                .searchable(text: $viewModel.searchTerm)
                .onSubmit(of: .search) {
                    Task {
                        await viewModel.executeQuery()
                    }
                }
            }
            .navigationTitle("Search Weather")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
