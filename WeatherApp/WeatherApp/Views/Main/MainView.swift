import SwiftUI

struct MainView: View {
    
    // MARK: - Properties

    @StateObject private var viewModel: CitiesViewModel = CitiesViewModelCreator().factoryMethod(parser: NetworkParser())

    // MARK: - Body

    var body: some View {
        NavigationStack {
            List(viewModel.cities) { city in
                NavigationLink(value: city.id) {
                    CityCard(cityInfo: city)
                }
                .foregroundColor(.black)
            }
            .navigationDestination(for: City.ID.self, destination: { cityID in
                let city = self.viewModel.cities.first(where: { $0.id == cityID })
                CityWeatherView(cityElement: city)
            })
            .searchable(text: $viewModel.searchTerm)
            .navigationTitle("Search Weather")
        }
    }
}

struct MainView_Previews: PreviewProvider {

    static var previews: some View {
        MainView()
    }
}
