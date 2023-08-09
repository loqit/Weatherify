import Foundation
import Combine

class CitiesViewModel: ViewModelProtocol {
    
    // MARK: Properties
    
    @Published private(set) var cities: [City] = []
    @Published private(set) var isSearching = false
    @Published var searchTerm: String = ""
    @Published private(set) var error: Error?
    
    private var subscriptions: Set<AnyCancellable> = []
    private let citiesFetcher: CityServiceProtocol
    
    // MARK: - Init

    init(service: CityServiceProtocol) {
        citiesFetcher = service
        subscribeToSearch()
    }
    
    // MARK: Public
    
    func load() async {
        await toggleSearch()
        let currentSearchCity = searchTerm.trimmingCharacters(in: .whitespaces)
        if currentSearchCity.isEmpty {
            await setCities(with: [])
        } else {
            await searchCities(by: searchTerm)
        }
    }
    
    // MARK: Private
    
    private func subscribeToSearch() {
        $searchTerm
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .dropFirst()
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .sink { cityName in
                Task {
                    await self.searchCities(by: cityName)
                }
            }
            .store(in: &subscriptions)
    }
    
    @MainActor
    private func toggleSearch() {
        isSearching.toggle()
    }
    
    @MainActor
    private func setCities(with data: [City]?, _ error: Error? = nil) {
        cities = data ?? []
        toggleSearch()
        self.error = error
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
