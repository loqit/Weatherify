import Foundation
import Combine

class CitiesViewModel: ViewModelProtocol {
    
    @Published private(set) var cities: [City] = []
    @Published private(set) var isSearching = false
    @Published var searchTerm: String = ""
    private var searchTask: Task<Void, Never>?
    
    private let citiesFetcher: CityServiceProtocol
    
    init(service: CityServiceProtocol) {
        citiesFetcher = service
    }

    func load() async {
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
    
    private func searchCities(by name: String) async -> [City] {
        do {
            let cities: [City] = try await citiesFetcher.getCitiesData(of: name)
            return cities
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
}
