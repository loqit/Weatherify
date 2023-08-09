import SwiftUI
import ComposableArchitecture

struct SearchCityView: View {

    let store: StoreOf<SearchCityReducer>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack {
                List(viewStore.cities) { city in
                    NavigationLink(value: city.id) {
                        CityCard(cityInfo: city)
                    }
                    .foregroundColor(.black)
                }
                .navigationDestination(for: City.ID.self) { cityID in
                    let city = viewStore.cities.first(where: { $0.id == cityID })
                    CityWeatherView(store: Store(initialState: CityWeatherReducer.State(),
                                                 reducer: {
                        CityWeatherReducer()
                            ._printChanges()
                    }), cityElement: city)
                }
                .searchable(text: viewStore.binding(get: \.searchQuery,
                                                    send: SearchCityReducer.Action.searchQueryChanged)
                )
                .task(id: viewStore.searchQuery) {
                    do {
                        try await Task.sleep(nanoseconds: NSEC_PER_SEC / 3)
                        await viewStore.send(.searchQueryDebounced).finish()
                    } catch {}
                }
                .navigationTitle("Search Weather")
            }
        }
    }
}
