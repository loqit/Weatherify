import Foundation
import Combine
import SwiftUI

class WeatherViewModel: ViewModelProtocol {
    
    @Published var weatherData: WeatherModel?
    @Published private(set) var isSearching = false
    var city: City?
    
    private var weatherFetcher: WeatherServiceProtocol
    
    init(service: WeatherServiceProtocol) {
        weatherFetcher = service
    }
    
    private var searchTask: Task<Void, Never>?

    func load() async {
        searchTask?.cancel()
        guard let city = city else {
            return
        }
        searchTask = Task {
            isSearching = true
            weatherData = await searchWeather(at: city)
            isSearching = Task.isCancelled
        }
    }

    private func searchWeather(at city: City) async -> WeatherModel? {
        do {
            let weatherResponse: WeatherModel = try await weatherFetcher.fetchWeatherModel(by: city)
            print("Fetched response - ", weatherResponse.lat)
            return weatherResponse
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
