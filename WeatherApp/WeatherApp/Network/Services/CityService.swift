import Foundation

protocol CityServiceProtocol {
  func getCitiesData(of cityName: String) async throws -> Result<[City], Error>
}

class CityService: CityServiceProtocol {
  
  private let networkService: NetworkServiceProtocol
  
  init(service: NetworkServiceProtocol) {
    networkService = service
  }
  
//  func getCitiesData(of cityName: String) async throws -> Result<[City], Error> {
//    do {
//      let url = OpenWeatherEndpoint.geoUrl(cityName).url
//      return try await networkService.fetchResponse(from: url)
//    } catch {
//      throw error
//    }
//  }
  
  func getCitiesData(of cityName: String) async throws -> Result<[City], Error> {
    let url = OpenWeatherEndpoint.geoUrl(cityName).url
    let dataFetcher = CityDataFetcherService(networkService: networkService)
    let data: Result<[City], Error> = await dataFetcher.fetchData(from: url, cityName)
    return data
  }
}
