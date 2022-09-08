import SwiftUI

struct CountriesView: View {
    
    @StateObject private var viewModel: CountriesViewModel = CountriesViewModel()

    var body: some View {
        let countries = viewModel.countries
        NavigationView {
            List(countries) { country in
                NavigationLink(destination: WeatherMapView(name: country.capital[0])) {
                    CountryCard(countryName: country.name.common, countryFlag: country.flags.png)
                }
            }
            .searchable(text: $viewModel.searchTerm)
            .onSubmit(of: .search) {
                Task {
                    await viewModel.loadCountriesList()
                }
            }
            .onAppear {
                Task {
                    await viewModel.loadCountriesList()
                }
            }
        }
        .navigationTitle("Countries")
    }
}

struct CountriesView_Previews: PreviewProvider {
    static var previews: some View {
        CountriesView()
    }
}
