import Foundation

class CountryService: CountriesServiceProtocol {
    
    // MARK: - Properties
    
    private let networkService: NetworkServiceProtocol
    
    init(service: NetworkServiceProtocol) {
        networkService = service
    }
    
    // MARK: - Public
    
    func getCountry(by name: String = "") async throws -> Result<[CountryElement]?, Error> {
        do {
            var url: URL
            if name.isEmpty {
                url = CountriesEndpoint.all.url
            } else {
                url = CountriesEndpoint.name(name).url
            }
            return try await networkService.fetchResponse(from: url)
        } catch {
            throw error
        }
    }
}
