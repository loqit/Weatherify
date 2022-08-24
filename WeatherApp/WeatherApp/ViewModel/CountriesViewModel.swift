import Foundation

class CountriesViewModel: ObservableObject {
    
    @Published private(set) var countries: [CountryElement] = []
    @Published private(set) var isSearching = false
    @Published var searchTerm: String = ""
    private var loadTask: Task<Void, Never>?
    
    private let dataFetcher: CountriesServiceProtocol
    
    init(service: CountriesServiceProtocol) {
        dataFetcher = service
    }
    
    init() {
        dataFetcher = CountryService(service: NetworkService())
    }
    
    @MainActor
    func loadCountriesList() async {
        loadTask?.cancel()
        let currentSearchCountry = searchTerm.trimmingCharacters(in: .whitespaces)
        if currentSearchCountry.isEmpty {
            loadTask = Task {
                countries = await getCountriesList()
            }
        } else {
            loadTask = Task {
                countries = await getCountry(by: currentSearchCountry) ?? []
            }
        }
    }

    private func getCountriesList() async -> [CountryElement] {
        do {
            let countries: [CountryElement] = try await dataFetcher.getContriesList()
            return countries
        } catch {
            print(error)
            print(error.localizedDescription)
            return []
        }
    }
    
    private func getCountry(by name: String) async -> [CountryElement]? {
        do {
            let countries: [CountryElement]? = try await dataFetcher.getCountry(by: name)
            return countries
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
}
