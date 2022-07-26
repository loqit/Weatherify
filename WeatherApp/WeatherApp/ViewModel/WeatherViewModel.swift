import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    
    @Published private(set) var weatherData: [ResponseList] = []
    @Published private(set) var city: [City] = []
    @Published private(set) var isSearching = false
    private let weatherFetcher = WeatherFetcher()
    
    private var searchTask: Task<Void, Never>?

    @MainActor
    func load(for cityElement: CityElement) async {
        searchTask?.cancel()
        searchTask = Task {
            isSearching = true
            let cityData: City?
            (weatherData, cityData) = await searchWeather(at: cityElement)
            if let cityData = cityData {
                city = []
                city.append(cityData)
            }
            isSearching = Task.isCancelled
        }
    }

    private func searchWeather(at city: CityElement) async -> ([ResponseList], City?) {
        do {
            let weatherResponse: ResponseBody = try await weatherFetcher.fetchWeatherData(by: city)
            return (weatherResponse.list, weatherResponse.city)
        } catch {
            print(error.localizedDescription)
            return ([], nil)
        }
    }
}
