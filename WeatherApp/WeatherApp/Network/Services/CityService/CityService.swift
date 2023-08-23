import Foundation
import Dependencies

class CityService: CityServiceProtocol {
    
    // MARK: - Properties

    private let networkService: NetworkServiceProtocol
    private let dataFetcher: CityDataFetcherService
    
    init(service: NetworkServiceProtocol) {
        networkService = service
        dataFetcher = CityDataFetcherService(networkService: networkService)
    }

    // MARK: - Public

    func getCitiesData(of cityName: String) async throws -> Result<[City], NetworkError> {
        let url = OpenWeatherEndpoint.geoUrl(cityName).url
        let data: Result<[City], NetworkError> = try await dataFetcher.fetchData(from: url, cityName)
        return data
    }
}

// MARK: - Dependecy

extension DependencyValues {
    
    var cityService: CityService {
        get { self[CityService.self] }
        set { self[CityService.self] = newValue }
    }
}

extension CityService: DependencyKey {
    
    static let liveValue = CityService(service: NetworkService(parser: NetworkParser()))
}
