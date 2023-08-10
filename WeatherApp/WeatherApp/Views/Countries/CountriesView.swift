import SwiftUI
import ComposableArchitecture
import CoreLocation

struct CountriesView: View {

    // MARK: - Properties

    let store: StoreOf<CountriesReducer>

    @State private var isError = false
    @State private var isLoading = false
    
    // MARK: - Body

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack {
                List(viewStore.countries) { country in
                    NavigationLink(value: country.id) {
                        countryCard(of: country)
                    }
                }
                .navigationDestination(for: CountryElement.ID.self, destination: { countryID in
                    let country = viewStore.countries.first(where: { $0.id == countryID })
                    WeatherMapView(coordinate: country?.coordinate)
                })
                .overlay(loadingOverlay)
                .searchable(text: viewStore.binding(get: \.searchQuery,
                                                    send: CountriesReducer.Action.searchQueryChanged ))
              //  .onReceive(viewModel.$isSearching) { isLoading = $0 }
                .task(id: viewStore.searchQuery) {
                    do {
                        try await Task.sleep(nanoseconds: NSEC_PER_SEC / 3)
                        await viewStore.send(.searchQueryChangeDebounced).finish()
                    } catch {}
                }
                .navigationTitle("Countries")
            }
//            .alert("Failed to load Countries list", isPresented: self.$viewModel.isError) {
//                Button("Ok", role: .cancel, action: {})
//            }
        }
    }
    
    // MARK: - Private
    
    private func countryCard(of coutry: CountryElement) -> some View {
        CountryCard(countryName: coutry.name.common, countryFlag: coutry.flags.png)
    }

    @ViewBuilder private var loadingOverlay: some View {
        if isLoading {
            ProgressView()
        }
    }
}
