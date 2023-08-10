import Foundation
import ComposableArchitecture

struct CityWeatherReducer: Reducer {
    
    @Dependency(\.weatherService)
    var weatherService
    
    enum CancelID {
        
        case loading
    }
    
    // MARK: - State

    struct State: Equatable {
        
        var weatherData: WeatherModel?
        var isWeatherRequestInFlight = false
    }
    
    // MARK: - Action

    enum Action {

        case requestWeather(_ lat: Double, _ lon: Double)
        case weatherResponse(Result<WeatherModel, Error>)
    }
    
    // MARK: - Reduce

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .requestWeather(lat, lon):
            state.isWeatherRequestInFlight = true
            return .run { send in
                await send(.weatherResponse( try await weatherService.fetchWeatherModel(lat, lon) ))
            }
            .cancellable(id: CancelID.loading)
        case .weatherResponse(.failure):
            state.isWeatherRequestInFlight = false
            state.weatherData = nil
            return .none
        case let .weatherResponse(.success(weather)):
            state.isWeatherRequestInFlight = false
            state.weatherData = weather
            return .none
        }
    }
}
