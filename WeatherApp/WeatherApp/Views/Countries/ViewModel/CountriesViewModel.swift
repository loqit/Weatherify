import Foundation
import Combine

class CountriesViewModel: ViewModelProtocol {
    
    // MARK: Properties
    
    @Published private(set) var countries: [CountryElement] = []
    @Published private(set) var error: Error?
    @Published private(set) var isSearching = false
    @Published var isError = false
    @Published var searchTerm: String = ""
    
    private let reachability = NetworkReachability()
    private let dataFetcher: CountriesServiceProtocol
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init(service: CountriesServiceProtocol) {
        dataFetcher = service
        subcribeToSearch()
    }
    
    // MARK: Public

    func load() async {
        await toggleSearch()
        await resetError()
        
        if reachability.isNetworkAvailable() {
            let currentSearchCountry = searchTerm.trimmingCharacters(in: .whitespaces)
            await getCountry(by: currentSearchCountry)
        }
    }
    
    // MARK: Private
    
    private func subcribeToSearch() {
        $searchTerm
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .dropFirst()
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .sink { countryName in
                Task {
                    await self.getCountry(by: countryName)
                }
            }
            .store(in: &subscriptions)
    }
    
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
        toggleSearch()
        countries = data
        self.error = error
        resetError()
    }
    
    private func getCountry(by name: String) async {
        do {
            async let countriesResult = try await dataFetcher.getCountry(by: name)
            switch try await countriesResult {
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
