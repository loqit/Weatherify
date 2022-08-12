import Foundation

class CountriesViewModel: ObservableObject {
    
    @Published private(set) var countries: [CountryElement] = []
    private let dataFetcher = DataFetcher()
    private var loadTask: Task<Void, Never>?
    
    @MainActor
    func loadCountriesList() async {
        loadTask?.cancel()
        loadTask = Task {
            countries = await getCountriesList()
        }
    }
    
    private func getCountriesList() async -> [CountryElement] {
        do {
            let countries: [CountryElement] = try await dataFetcher.getContriesList()
            return countries
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
}
