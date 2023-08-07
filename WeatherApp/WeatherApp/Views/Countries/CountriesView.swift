import SwiftUI
import CoreLocation

struct CountriesView: View {
    
    @StateObject private var viewModel: CountriesViewModel = CountriesViewModelCreator().factoryMethod(parser: NetworkParser())
    @State private var isError = false
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            List(viewModel.countries) { country in
                NavigationLink(value: country.id) {
                    countryCard(of: country)
                }
            }
            .navigationDestination(for: CountryElement.ID.self, destination: { countryID in
                let country = viewModel.countries.first(where: { $0.id == countryID })
                WeatherMapView(coordinate: country?.coordinate)
            })
            .id(UUID())
            .overlay(loadingOverlay)
            .searchable(text: $viewModel.searchTerm)
            .onReceive(viewModel.$isSearching) { isLoading = $0 }
            .task {
                await viewModel.load()
            }
            .navigationTitle("Countries")
        }
        .alert("Failed to load Countries list", isPresented: self.$viewModel.isError) {
            Button("Ok", role: .cancel, action: {})
        }
    }
    
    // MARK: - Private
    
    private func countryCard(of coutry: CountryElement) -> some View {
        CountryCard(countryName: coutry.name.common, countryFlag: coutry.flags.png)
    }

    @ViewBuilder
    private var loadingOverlay: some View {
        if isLoading {
            ProgressView()
        }
    }
}

struct CountriesView_Previews: PreviewProvider {

    static var previews: some View {
        CountriesView()
    }
}
