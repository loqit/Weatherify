import Foundation
import Combine
import SwiftUI

class DataFetcher {

    private func getData<T: Codable>(from urlStr: String) async throws -> T {
        guard let url = URL(string: urlStr) else {
            throw NetworkError.inavlidData
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(T.self, from: data)
        return response
    }
    
    func getCitiesData(of cityName: String) async throws -> [CityElement] {
        let urlStr = "\(NetworkConstants.geoUrl)?q=\(cityName)&limit=5&appid=\(NetworkConstants.apiKey)"
        return try await getData(from: urlStr)
    }
    
    func fetchWeatherData(by cityElement: CityElement) async throws -> ResponseBody {
        let urlStr = "\(NetworkConstants.oneCallUrl)?lat=\(cityElement.lat)&lon=\(cityElement.lon)&exclude=alerts&appid=\(NetworkConstants.apiKey)&units=metric"
        return try await getData(from: urlStr)
    }
    
    func getContriesList() async throws -> CountryElement {
        let urlStr = "https://restcountries.com/v3.1/all"
        return try await getData(from: urlStr)
    }
}
