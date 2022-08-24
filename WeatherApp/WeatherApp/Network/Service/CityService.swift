import Foundation

protocol CityServiceProtocol {
    func getCitiesData(of cityName: String) async throws -> [CityElement]
}

class CityService: CityServiceProtocol {

    private let networkService: NetworkServiceProtocol
    
    init(service: NetworkServiceProtocol) {
        networkService = service
    }

    func getCitiesData(of cityName: String) async throws -> [CityElement] {
        let url = OpenWeatherEndpoint.geoUrl(cityName).url
        return try await networkService.getData(from: url)
    }
}
