import Foundation
import Combine
import SwiftUI

class WeatherFetcher {

    private func getData<T: Codable>(from url: URL) async throws -> T {
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(T.self, from: data)
        return response
    }
    
    func getCitiesData(of cityName: String) async throws -> [CityElement] {
        // swiftlint:disable line_length
        guard let url = URL(
            string: "\(NetworkConstants.geoUrl)?q=\(cityName)&limit=5&appid=\(NetworkConstants.apiKey)")
        else {
            throw NetworkError.invalidUrl
        }
        let cityElemants: [CityElement] = try await getData(from: url)
        return cityElemants
    }
    
    func fetchWeatherData(by cityElement: CityElement) async throws -> ResponseBody {
        guard let url = URL(string: "\(NetworkConstants.oneCallUrl)?lat=\(cityElement.lat)&lon=\(cityElement.lon)&exclude=alerts&appid=\(NetworkConstants.apiKey)&units=metric")
        else {
            throw NetworkError.invalidUrl
        }
        return try await getData(from: url)
    }
}
