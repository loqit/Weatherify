import SwiftUI
import ComposableArchitecture
import CoreLocation

struct CountriesView: View {

    // MARK: - Properties

    let store: StoreOf<CountriesReducer>

    @State private var isError = false

    // MARK: - Body

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack {
                ScrollView {
                    LazyVStack {
                        ForEach(viewStore.countries) { country in
                            NavigationLink(value: country.id) {
                                countryCard(of: country)
                            }
                            .padding(EdgeInsets(top: 7, leading: 10, bottom: 3, trailing: 10))
                        }
                    }
                }
                .navigationDestination(for: CountryElement.ID.self) { countryID in
                    let country = viewStore.countries.first(where: { $0.id == countryID })
                    WeatherMapView(coordinate: country?.coordinate)
                }
                .overlay(loadingOverlay(isLoading: viewStore.isCountryRequestInFlight))
                .searchable(text: viewStore.binding(get: \.searchQuery,
                                                    send: CountriesReducer.Action.searchQueryChanged ))
                .task(id: viewStore.searchQuery) {
                    do {
                        try await Task.sleep(nanoseconds: NSEC_PER_SEC / 3)
                        await viewStore.send(.searchQueryChangeDebounced).finish()
                    } catch {}
                }
                .navigationTitle("Countries")
            }
        }
    }

    // MARK: - Private

    private func countryCard(of coutry: CountryElement) -> some View {
        CountryCard(countryName: coutry.name.common, countryFlag: coutry.flags.png)
    }

    @ViewBuilder
    private func loadingOverlay(isLoading: Bool) -> some View {
        if isLoading {
            ProgressView()
        }
    }
}
