import Foundation

protocol WeatherServiceProtocol {
    
    func fetchWeatherModel(_ lat: Double, _ lon: Double) async throws -> Result<WeatherModel, NetworkError>
}
