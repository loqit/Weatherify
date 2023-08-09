import Foundation
import ComposableArchitecture

extension DependencyValues {
    
    var weatherService: WeatherService {
        get { self[WeatherService.self] }
        set { self[WeatherService.self] = newValue }
    }
}

extension WeatherService: DependencyKey {
    
    static let liveValue = WeatherService(service: NetworkService(parser: NetworkParser()))
}

struct CityWeatherReducer: Reducer {
    
    @Dependency(\.weatherService) var weatherService
    
    // MARK: - State

    struct State: Equatable {
        
        var weatherData: WeatherModel?
        
        static func == (lhs: CityWeatherReducer.State, rhs: CityWeatherReducer.State) -> Bool {
            lhs.weatherData == rhs.weatherData
        }
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
            return .run { send in
                await send(.weatherResponse( try await weatherService.fetchWeatherModel(lat, lon) ))
            }
        case .weatherResponse(.failure):
            state.weatherData = nil
            return .none
        case let .weatherResponse(.success(weather)):
            state.weatherData = weather
            return .none
        }
    }
}
