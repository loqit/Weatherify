import Foundation

class CityService: CityServiceProtocol {
    
    // MARK: - Properties

    private let networkService: NetworkServiceProtocol
    
    init(service: NetworkServiceProtocol) {
        networkService = service
    }

    // MARK: - Public

    func getCitiesData(of cityName: String) async throws -> Result<[City], Error> {
        let url = OpenWeatherEndpoint.geoUrl(cityName).url
        let dataFetcher = CityDataFetcherService(networkService: networkService)
        let data: Result<[City], Error> = await dataFetcher.fetchData(from: url, cityName)
        return data
    }
}
