import Foundation

protocol CityServiceProtocol {
    func getCitiesData(of cityName: String) async throws -> Result<[City], Error>
}

class CityService: CityServiceProtocol {

    private let networkService: NetworkServiceProtocol
    
    init(service: NetworkServiceProtocol) {
        networkService = service
    }

    func getCitiesData(of cityName: String) async throws -> Result<[City], Error> {
        do {
            let url = OpenWeatherEndpoint.geoUrl(cityName).url
            let result: Result<[City], Error> = try await networkService.fetchResponse(from: url)
            return result
        } catch {
            throw error
        }
    }
}
