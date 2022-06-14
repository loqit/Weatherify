import Foundation

struct CityElement: Codable {
    let name: String
    let localNames: LocalNamesData
    let lat, lon: Double
    let country: String
    let state: String?

    enum CodingKeys: String, CodingKey {
        case name
        case localNames = "local_names"
        case lat, lon, country, state
    }
}
