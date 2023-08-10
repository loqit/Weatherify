import Foundation
import ComposableArchitecture

struct CityWeatherReducer: Reducer {
    
    // MARK: - Properties

    @Dependency(\.weatherService)
    var weatherService
    
    enum CancelID {
        
        case loading
    }
    
    // MARK: - State

    struct State: Equatable {

        var id: String?
        var weatherData: WeatherModel?
        var isWeatherRequestInFlight = false
    }
    
    // MARK: - Action

    enum Action {

        case requestWeather(_ lat: Double, _ lon: Double)
        case weatherResponse(String, Result<WeatherModel, Error>)
    }
    
    // MARK: - Reduce
    // swiftlint:disable function_body_length
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .requestWeather(lat, lon):
            state.isWeatherRequestInFlight = true
            return .run { send in
                async let response = try weatherService.fetchWeatherModel(lat, lon)
                await send(.weatherResponse( "\(lat) \(lon)", try await response ))
            }
            .cancellable(id: CancelID.loading)
        case let .weatherResponse(id, .failure):
            state.id = id
            state.isWeatherRequestInFlight = false
            state.weatherData = nil
            return .none
        case let .weatherResponse(id, .success(weather)):
            state.id = id
            state.isWeatherRequestInFlight = false
            state.weatherData = weather
            return .none
        }
    }
}
