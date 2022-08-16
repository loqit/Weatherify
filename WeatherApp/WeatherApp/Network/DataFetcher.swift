import Foundation
import Combine
import SwiftUI

class DataFetcher {
    private func getData<T: Codable>(from url: URL) async throws -> T {
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(T.self, from: data)
        return response
    }
    
    func getCitiesData(of cityName: String) async throws -> [CityElement] {
        let url = OpenWeatherEndpoint.geoUrl(cityName).url
        return try await getData(from: url)
    }
    
    func fetchWeatherData(by cityElement: CityElement) async throws -> ResponseBody {
        let lat = String(cityElement.lat)
        let lon = String(cityElement.lon)
        let url = OpenWeatherEndpoint.oneCallUrl(lat, lon).url
        return try await getData(from: url)
    }
    
    func getContriesList() async throws -> [CountryElement] {
        let url = CountriesEndpoint.all.url
        return try await getData(from: url)
    }
    
    func getCountry(by name: String) async throws -> [CountryElement]? {
        let url = CountriesEndpoint.name(name).url
        return try await getData(from: url)
    }
}
