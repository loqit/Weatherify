import Foundation
import Combine

class WeatherViewModel: ViewModelProtocol {
  
  @Published var weatherData: WeatherModel?
  @Published private(set) var isSearching = false
  @Published private(set) var error: Error?
  var city: City?
  
  private var weatherFetcher: WeatherServiceProtocol
  
  init(service: WeatherServiceProtocol) {
    weatherFetcher = service
  }
  
  func load() async {
    isSearching = true
    guard let city = city else {
      return
    }
    await searchWeather(at: city)
  }
  
  @MainActor
  private func setWeather(with data: WeatherModel?, _ error: Error? = nil) {
    weatherData = data
    isSearching = false
    if error != nil {
      self.error = error
    }
  }
  
  private func searchWeather(at city: City) async {
    do {
      let weatherResult = try await weatherFetcher.fetchWeatherModel(city.lat, city.lon)
      switch weatherResult {
      case .success(let data):
        await setWeather(with: data)
      case .failure(let error):
        await setWeather(with: nil, error)
      }
    } catch {
      await setWeather(with: nil, error)
    }
  }
}
