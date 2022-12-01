import Foundation

protocol WeatherServiceProtocol {
  func fetchWeatherModel(_ lat: Double, _ lon: Double) async throws -> Result<WeatherModel, Error>
}

class WeatherService: WeatherServiceProtocol {
  
  private let networkService: NetworkServiceProtocol
  
  init(service: NetworkServiceProtocol) {
    networkService = service
  }
  
//  func fetchWeatherModel(_ lat: Double, _ lon: Double) async throws -> Result<WeatherModel, Error> {
//    do {
//      let url = OpenWeatherEndpoint.oneCallUrl(lat, lon).url
//      return try await networkService.fetchResponse(from: url)
//    } catch {
//      throw error
//    }
//  }
  
  func fetchWeatherModel(_ lat: Double, _ lon: Double) async throws -> Result<WeatherModel, Error> {
    let url = OpenWeatherEndpoint.oneCallUrl(lat, lon).url
    let dataFetcher = WeatherDataFetcherService(networkService: networkService)
    let cityID = HashService.getHash(from: lat.round(to: 3), and: lon.round(to: 3))
    let data: Result<WeatherModel, Error> = await dataFetcher.fetchData(from: url, cityID)
    return data
  }
}
