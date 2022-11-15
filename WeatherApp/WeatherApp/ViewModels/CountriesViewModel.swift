import Foundation

class CountriesViewModel: ViewModelProtocol {
  
  @Published private(set) var countries: [CountryElement] = []
  @Published private(set) var error: Error?
  @Published var isError = false
  @Published private(set) var isSearching = false
  @Published var searchTerm: String = ""
  
  private let dataFetcher: CountriesServiceProtocol
  
  init(service: CountriesServiceProtocol) {
    dataFetcher = service
  }
  
  func load() async {
    isSearching = true
    isError = false
    let currentSearchCountry = searchTerm.trimmingCharacters(in: .whitespaces)
    await getCountry(by: currentSearchCountry)
  }

  @MainActor
  private func setCountries(with data: [CountryElement], _ error: Error? = nil) {
    countries = data
    isSearching = false
    if error != nil {
      self.error = error
      isError = true
    }
  }
  
  private func getCountry(by name: String) async {
    do {
      let countriesResult = try await dataFetcher.getCountry(by: name)
      switch countriesResult {
      case .success(let data):
        await setCountries(with: data ?? [])
      case .failure(let error):
        await setCountries(with: [], error)
      }
    } catch {
      await setCountries(with: [], error)
    }
  }
}
