import Foundation
import Combine
import SwiftUI

class WeatherViewModel: ViewModelProtocol {
    
    @Published var weatherData: WeatherModel?
    @Published private(set) var isSearching = false
    @Published private(set) var error: Error?
    var city: City?
    
    private var weatherFetcher: WeatherServiceProtocol
    
    init(service: WeatherServiceProtocol) {
        weatherFetcher = service
    }
    
    private var searchTask: Task<Void, Never>?

    func load() async {
        searchTask?.cancel()
        isSearching = true
        guard let city = city else {
            return
        }
        searchTask = Task {
            await searchWeather(at: city)
        }
    }
    
    @MainActor
    private func setWeather(with data: WeatherModel?, _ error: Error? = nil) {
        weatherData = data
        isSearching = false
    }

    private func searchWeather(at city: City) async {
        do {
            let lat = city.lat
            let lon = city.lon
            let weatherResult: Result<WeatherModel, Error> = try await weatherFetcher.fetchWeatherModel(lat, lon)
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
