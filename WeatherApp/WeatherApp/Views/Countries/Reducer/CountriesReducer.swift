import Foundation
import ComposableArchitecture

struct CountriesReducer: Reducer {
    
    // MARK: - Propreties
    
    @Dependency(\.countryService)
    var countryService

    enum CancellID {
        
        case search
    }
    
    // MARK: - State
    
    struct State: Equatable {
        
        var countries: [CountryElement] = []
        var searchQuery = ""
        var isCountryRequestInFlight = false
        var isErrorOccured = false
    }

    // MARK: - Action

    enum Action {
        
        case searchQueryChanged(String)
        case searchQueryChangeDebounced
        case searchResponse(Result<[CountryElement]?, NetworkError>)
    }

    // MARK: - Reduce

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .searchQueryChanged(query):
            state.searchQuery = query
            return .none
        case .searchQueryChangeDebounced:
            state.isCountryRequestInFlight = true
            return .run { [query = state.searchQuery] send in
                await send(.searchResponse( try countryService.getCountry(by: query) ))
            }
            .cancellable(id: CancellID.search)
        case let .searchResponse(.success(countries)):
            state.isCountryRequestInFlight = false
            state.countries = countries ?? []
            return .none
        case .searchResponse(.failure):
            state.isCountryRequestInFlight = false
            state.isErrorOccured = true
            state.countries = []
            return .none
        }
    }
}
