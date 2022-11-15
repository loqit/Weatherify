import SwiftUI

struct CountriesView: View {
    
    @StateObject private var viewModel: CountriesViewModel = CountriesViewModelCreator().factoryMethod(parser: NetworkParser())
    @State private var isError = false
    @State private var isLoading = false

    var body: some View {
        let countries = viewModel.countries
        NavigationView {
            List(countries) { country in
                NavigationLink(destination: WeatherMapView(coordinate: country.coordinate())) {
                    
                    CountryCard(countryName: country.name.common, countryFlag: country.flags.png)
                }
            }
            .overlay(loadingOverlay)
            .searchable(text: $viewModel.searchTerm)
            .onSubmit(of: .search) {
                Task {
                    await viewModel.load()
                }
            }
            .onReceive(viewModel.$isSearching, perform: { value in
                isLoading = value
            })
            .task {
                await viewModel.load()
            }
            .navigationTitle("Countries")
        }
        .alert("Failed to load Countries list", isPresented: self.$viewModel.isError) {
            Button("Ok", role: .cancel, action: {})
        }
    }
    
    @ViewBuilder private var loadingOverlay: some View {
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
