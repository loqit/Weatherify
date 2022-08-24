import Foundation

protocol CountriesServiceProtocol {
    func getContriesList() async throws -> [CountryElement]
    func getCountry(by name: String) async throws -> [CountryElement]?
}

class CountryService: CountriesServiceProtocol {
    
    private let networkService: NetworkServiceProtocol
    
    init(service: NetworkServiceProtocol) {
        networkService = service
    }

    func getContriesList() async throws -> [CountryElement] {
        let url = CountriesEndpoint.all.url
        return try await networkService.getData(from: url)
    }
    
    func getCountry(by name: String) async throws -> [CountryElement]? {
        let url = CountriesEndpoint.name(name).url
        return try await networkService.getData(from: url)
    }
}
