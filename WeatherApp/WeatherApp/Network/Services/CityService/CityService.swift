import Foundation

class CityService: CityServiceProtocol {
    
    // MARK: - Properties

    private let networkService: NetworkServiceProtocol
    private let dataFetcher: CityDataFetcherService
    
    init(service: NetworkServiceProtocol) {
        networkService = service
        dataFetcher = CityDataFetcherService(networkService: networkService)
    }

    // MARK: - Public

    func getCitiesData(of cityName: String) async throws -> Result<[City], Error> {
        let url = OpenWeatherEndpoint.geoUrl(cityName).url
        let data: Result<[City], Error> = try await dataFetcher.fetchData(from: url, cityName)
        return data
    }
}
