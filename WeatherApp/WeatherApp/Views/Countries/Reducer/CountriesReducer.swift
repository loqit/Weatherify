import Foundation
import ComposableArchitecture

extension DependencyValues {
    
    var countryService: CountryService {
        get { self[CountryService.self] }
        set { self[CountryService.self] = newValue }
    }
}

extension CountryService: DependencyKey {
    
    static let liveValue = CountryService(service: NetworkService(parser: NetworkParser()))
}

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
    }

    // MARK: - Action

    enum Action {
        
        case searchQueryChanged(String)
        case searchQueryChangeDebounced
        case searchResponse(Result<[CountryElement]?, Error>)
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .searchQueryChanged(query):
            state.searchQuery = query
            return .none
        case .searchQueryChangeDebounced:
            return .run { [query = state.searchQuery] send in
                await send(.searchResponse( try countryService.getCountry(by: query) ))
            }
            .cancellable(id: CancellID.search)
        case let .searchResponse(.success(countries)):
            state.countries = countries ?? []
            return .none
        case .searchResponse(.failure):
            state.countries = []
            return .none
        }
    }
}
