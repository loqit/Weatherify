import Foundation
import ComposableArchitecture

extension DependencyValues {
    
    var cityService: CityService {
        get { self[CityService.self] }
        set { self[CityService.self] = newValue }
    }
}

extension CityService: DependencyKey {
    
    static let liveValue = CityService(service: NetworkService(parser: NetworkParser()))
}

struct SearchCityReducer: Reducer {

    @Dependency(\.cityService) var cityService
    
    private enum CancellID {
        
        case search
    }
    
    // MARK: - State
    
    struct State: Equatable {
        
        var cities: [City] = []
        var selectedCity: City?
        var searchQuery = ""
        var error: Error?
        
        static func == (lhs: SearchCityReducer.State, rhs: SearchCityReducer.State) -> Bool {
            lhs.cities == rhs.cities &&
            lhs.searchQuery == rhs.searchQuery &&
            lhs.selectedCity == rhs.selectedCity
        }
    }
    
    // MARK: - Action
    
    enum Action {
        
        case searchQueryChanged(String)
        case searchQueryDebounced
        case searchResponse(Result<[City], Error>)
        case searchResultTapped(City)
    }
    
    // MARK: - Reduce
    // swiftlint:disable function_body_length
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .searchQueryChanged(query):
            state.searchQuery = query
            guard !query.isEmpty else {
                state.cities = []
                return .cancel(id: CancellID.search)
            }
            return .none
        case .searchQueryDebounced:
            guard !state.searchQuery.isEmpty else {
                return .none
            }
            return .run { [query = state.searchQuery] send in
                await send(.searchResponse( try cityService.getCitiesData(of: query) ))
            }
            .cancellable(id: CancellID.search)
            
        case let .searchResponse(.success(cities)):
            state.cities = cities
            return .none
        case .searchResponse(.failure):
            state.cities = []
            return .none
        case let .searchResultTapped(city):
            state.selectedCity = city
            
            return .none
        }
    }
}
