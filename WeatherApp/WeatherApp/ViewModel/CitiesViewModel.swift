import Foundation
import Combine

class CitiesViewModel: ObservableObject {
    
    @Published private(set) var cities: [CityElement] = []
    @Published private(set) var isSearching = false
    @Published var searchTerm: String = ""
    private let weatherFetcher = WeatherFetcher()
    
    private var searchTask: Task<Void, Never>?
    
    @MainActor
    func executeQuery() async {
        searchTask?.cancel()
        let currentSearchCity = searchTerm.trimmingCharacters(in: .whitespaces)
        if currentSearchCity.isEmpty {
            cities = []
            isSearching = false
        } else {
            searchTask = Task {
                isSearching = true
                cities = await searchCities(by: searchTerm)
                isSearching = Task.isCancelled
            }
        }
    }
    
    private func searchCities(by name: String) async -> [CityElement] {
        do {
            let cities: [CityElement] = try await weatherFetcher.getCitiesData(of: name)
            return cities
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
}
