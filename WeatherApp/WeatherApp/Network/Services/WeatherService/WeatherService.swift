import Foundation
import Dependencies

class WeatherService: WeatherServiceProtocol {
    
    // MARK: - Properties

    private let networkService: NetworkServiceProtocol
    private let dataFetcher: WeatherDataFetcherService
    
    init(service: NetworkServiceProtocol) {
        networkService = service
        dataFetcher = WeatherDataFetcherService(networkService: networkService)
    }

    // MARK: - Private

    func fetchWeatherModel(_ lat: Double, _ lon: Double) async throws -> Result<WeatherModel, Error> {
        let url = OpenWeatherEndpoint.oneCallUrl(lat, lon).url
        let cityID = HashService.getHash(from: lat.round(to: 3), and: lon.round(to: 3))
        let data: Result<WeatherModel, Error> = await dataFetcher.fetchData(from: url, cityID)
        return data
    }
}

// MARK: - Dependecy

extension DependencyValues {
    
    var weatherService: WeatherService {
        get { self[WeatherService.self] }
        set { self[WeatherService.self] = newValue }
    }
}

extension WeatherService: DependencyKey {
    
    static let liveValue = WeatherService(service: NetworkService(parser: NetworkParser()))
}
