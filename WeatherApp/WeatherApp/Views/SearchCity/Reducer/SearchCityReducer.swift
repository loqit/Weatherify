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
        var savedCities: [String: Bool] = [:]
        var selectedCity: City?
        var searchQuery = ""
    }
    
    // MARK: - Action
    
    enum Action {
        
        case viewLoaded
        case citiesLoaded([String: Bool])
        case searchQueryChanged(String)
        case searchQueryDebounced
        case searchResponse(Result<[City], Error>)
        case saveButtonTapped(String)
        case citySaved(String)
        case cityDeleted(String)
    }
    
    // MARK: - Reduce

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .viewLoaded:
            return .run { send in
                await send(.citiesLoaded(await self.setupSavedCities()))
            }
        case let .citiesLoaded(savedCities):
            state.savedCities = savedCities
            return .none
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
        case let .saveButtonTapped(cityID):
            guard let city = state.cities.first(where: { $0.id == cityID }) else {
                return .none
            }
            return toggleSave(city: city)
        case let .citySaved(cityID):
            state.savedCities[cityID] = true
            return .none
        case let .cityDeleted(cityID):
            state.savedCities[cityID] = false
            return .none
        }
    }
    
    // MARK: - Private
    
    // TODO: - Refactor this method
    private func toggleSave(city: City) -> Effect<Action> {
        .run { send in
            let predicate = NSPredicate(format: "cityID = %@", city.id)
            async let result = await dataController.fetch(predicate: predicate)
            switch await result {
            case let .success(entities):
                if !entities.isEmpty {
                    async let result = await dataController.delete(entities[0])
                    switch await result {
                    case .success:
                        await send(.cityDeleted(city.id))
                    case .failure:
                        print("Delete Fail")
                    }
                } else {
                    async let result = await dataController.add { cityEntity in
                        cityEntity.name = city.name
                        cityEntity.id = UUID(uuidString: city.id)
                        cityEntity.country = city.country
                        cityEntity.state = city.state
                        cityEntity.cityID = city.id
                    }
                    switch await result {
                    case .success:
                        await send(.citySaved(city.id))
                    case .failure:
                        print("Save Failed")
                    }
                }
            case .failure:
                print("Some error occured")
            }
        }
    }
    
    private func setupSavedCities() async -> [String: Bool] {
        var savedCities: [String: Bool] = [:]
        async let result = await dataController.fetch()
        switch await result {
        case let .success(entities):
            entities.forEach { savedCities[$0.cityID ?? ""] = true }
        case .failure:
            print("Some error occured during load database")
        }
        return savedCities
    }
}
