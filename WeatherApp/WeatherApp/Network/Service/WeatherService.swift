import Foundation

protocol WeatherServiceProtocol {
    func fetchWeatherData(by cityElement: CityElement) async throws -> ResponseBody
}

class WeatherService: WeatherServiceProtocol {

    private let networkService: NetworkServiceProtocol
    
    init(service: NetworkServiceProtocol) {
        networkService = service
    }

    func fetchWeatherData(by cityElement: CityElement) async throws -> ResponseBody {
        let lat = String(cityElement.lat)
        let lon = String(cityElement.lon)
        let url = OpenWeatherEndpoint.oneCallUrl(lat, lon).url
        return try await networkService.getData(from: url)
    }
}
