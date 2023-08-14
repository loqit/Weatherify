import Foundation
import ComposableArchitecture

struct SearchCityReducer: Reducer {

    // MARK: - Properties

    @Dependency(\.cityService)
    var cityService
    
    private let dataController = CoreDataController<CityEntity>()
    
    private enum CancellID {
        
        case search
    }
    
    // MARK: - State
    
    struct State: Equatable {
        
        var cities: [City] = []
        var selectedCity: City?
        var searchQuery = ""
    }
    
    // MARK: - Action
    
    enum Action {
        
        case searchQueryChanged(String)
        case searchQueryDebounced
        case searchResponse(Result<[City], Error>)
        case saveButtonTapped(City)
    }
    
    // MARK: - Reduce
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
                async let response = try await cityService.getCitiesData(of: query)
                await send(.searchResponse( try await response ))
            }
            .cancellable(id: CancellID.search)
            
        case let .searchResponse(.success(cities)):
            state.cities = cities
            return .none
        case .searchResponse(.failure):
            state.cities = []
            return .none
        case let .saveButtonTapped(city):
            dataController.add { cityEntity in
                cityEntity.name = city.name
                cityEntity.id = UUID(uuidString: city.id)
                cityEntity.country = city.country
                cityEntity.state = city.state
                cityEntity.cityID = Int64(HashService.getHash(from: city.lat.round(to: 3),
                                                              and: city.lon.round(to: 3)))
            }
            .sink(receiveCompletion: { completion in
                print(completion)
            }) { cityEntity in
                print(cityEntity)
            }

            return .none
        }
    }
}
