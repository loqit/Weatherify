import Foundation

protocol WeatherServiceProtocol {
    func fetchWeatherModel(by cityElement: City) async throws -> WeatherModel
}

class WeatherService: WeatherServiceProtocol {

    private let networkService: NetworkServiceProtocol
    
    init(service: NetworkServiceProtocol) {
        networkService = service
    }

    func fetchWeatherModel(by cityElement: City) async throws -> WeatherModel {
        let lat = String(cityElement.lat)
        let lon = String(cityElement.lon)
        let url = OpenWeatherEndpoint.oneCallUrl(lat, lon).url
        let result: Result<WeatherModel, Error> = try await networkService.fetchResponse(from: url)
        switch result {
        case .success(let data):
            return data
        case .failure(let error):
            print(error)
            throw error
        }
      //  return try await networkService.fetchResponse(from: url)
    }
}
