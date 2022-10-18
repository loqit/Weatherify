import Foundation

protocol WeatherServiceProtocol {
    func fetchWeatherModel(_ lat: Double, _ lon: Double) async throws -> Result<WeatherModel, Error>
}

class WeatherService: WeatherServiceProtocol {

    private let networkService: NetworkServiceProtocol
    
    init(service: NetworkServiceProtocol) {
        networkService = service
    }

    func fetchWeatherModel(_ lat: Double, _ lon: Double) async throws -> Result<WeatherModel, Error> {
        do {
            let url = OpenWeatherEndpoint.oneCallUrl(lat, lon).url
           // let result: Result<WeatherModel, Error> =
            return try await networkService.fetchResponse(from: url)
        } catch {
            throw error
        }
    }
}
