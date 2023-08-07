import Foundation

protocol CityServiceProtocol {
    
    func getCitiesData(of cityName: String) async throws -> Result<[City], Error>
}
