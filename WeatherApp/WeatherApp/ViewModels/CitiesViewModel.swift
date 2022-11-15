import Foundation
import Combine

class CitiesViewModel: ViewModelProtocol {
  
  @Published private(set) var cities: [City] = []
  @Published private(set) var isSearching = false
  @Published var searchTerm: String = ""
  @Published private(set) var error: Error?
  
  private let citiesFetcher: CityServiceProtocol
  
  init(service: CityServiceProtocol) {
    citiesFetcher = service
  }
  
  func load() async {
    isSearching = true
    let currentSearchCity = searchTerm.trimmingCharacters(in: .whitespaces)
    if currentSearchCity.isEmpty {
      await setCities(with: [])
    } else {
      await searchCities(by: searchTerm)
    }
  }
  
  @MainActor
  private func setCities(with data: [City], _ error: Error? = nil) {
    cities = data
    isSearching = false
    if error != nil {
      self.error = error
    }
  }
  
  private func searchCities(by name: String) async {
    do {
      let citiesResult = try await citiesFetcher.getCitiesData(of: name)
      switch citiesResult {
      case .success(let data):
        await setCities(with: data)
      case .failure(let error):
        await setCities(with: [], error)
      }
    } catch {
      await setCities(with: [], error)
    }
  }
}
