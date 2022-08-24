import SwiftUI

struct MainView: View {
    @StateObject private var viewModel: CitiesViewModel = CitiesViewModel()
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

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
