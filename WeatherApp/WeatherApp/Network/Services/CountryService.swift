import Foundation

protocol CountriesServiceProtocol {
    func getCountry(by name: String) async throws -> Result<[CountryElement]?, Error>
}

class CountryService: CountriesServiceProtocol {
    
    private let networkService: NetworkServiceProtocol
    
    init(service: NetworkServiceProtocol) {
        networkService = service
    }

    func getCountry(by name: String) async throws -> Result<[CountryElement]?, Error> {
        do {
            var url: URL
            if name.isEmpty {
                url = CountriesEndpoint.all.url
            } else {
                url = CountriesEndpoint.name(name).url
            }
            let result: Result<[CountryElement]?, Error> = try await networkService.fetchResponse(from: url)
            return result
        } catch {
            throw error
        }
    }
}
