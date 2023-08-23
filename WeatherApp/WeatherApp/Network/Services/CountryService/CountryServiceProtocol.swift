import Foundation

protocol CountriesServiceProtocol {
    
    func getCountry(by name: String) async throws -> Result<[CountryElement]?, NetworkError>
}
