import Foundation

class CountriesViewModel: ViewModelProtocol {
    
    // MARK: Properties
    
    @Published private(set) var countries: [CountryElement] = []
    @Published private(set) var error: Error?
    @Published var isError = false
    @Published private(set) var isSearching = false
    @Published var searchTerm: String = ""
    
    private let reachability = NetworkReachability()
    private let dataFetcher: CountriesServiceProtocol
    
    init(service: CountriesServiceProtocol) {
        dataFetcher = service
    }
    
    // MARK: Public
    
    func load() async {
        await toggleSearch()
        await resetError()
        let currentSearchCountry = searchTerm.trimmingCharacters(in: .whitespaces)
        if reachability.isNetworkAvailable() {
            await getCountry(by: currentSearchCountry)
        } else {
            
        }
    }
    
    // MARK: Private
    
    @MainActor
    private func toggleSearch() {
        isSearching.toggle()
    }
    
    @MainActor
    private func resetError() {
        isError = error != nil
    }
    
    @MainActor
    private func setCountries(with data: [CountryElement], _ error: Error? = nil) {
        countries = data
        toggleSearch()
        if error != nil {
            self.error = error
            resetError()
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
