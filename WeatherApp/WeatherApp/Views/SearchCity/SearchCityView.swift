import SwiftUI
import ComposableArchitecture

struct SearchCityView: View {

    // MARK: - Properties

    let store: StoreOf<SearchCityReducer>

    // MARK: - Body

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack {
                ScrollView {
                    LazyVStack {
                        ForEach(viewStore.cities) { city in
                            NavigationLink(value: city.id) {
                                CityCard(store: store, model: .init(city: city))
                            }
                            .padding(EdgeInsets(top: 7, leading: 10, bottom: 3, trailing: 10))
                        }
                    }
                }
                .navigationDestination(for: City.ID.self) { cityID in
                    if let city = viewStore.cities.first(where: { $0.id == cityID }) {
                        CityWeatherView(
                            store: Store(initialState: CityWeatherReducer.State()) { CityWeatherReducer() },
                            weatherViewModel: .init(city: city)
                        )
                    }
                }
                .searchable(text: viewStore.binding(get: \.searchQuery,
                                                    send: SearchCityReducer.Action.searchQueryChanged)
                )
                .disableAutocorrection(true)
                .task(id: viewStore.searchQuery) {
                    do {
                        try await Task.sleep(nanoseconds: NSEC_PER_SEC / 3)
                        await viewStore.send(.searchQueryDebounced).finish()
                    } catch {}
                }
                .onAppear {
                    viewStore.send(.viewLoaded)
                }
                .navigationTitle("Search Weather")
            }
        }
    }
}
