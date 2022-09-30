import Foundation

struct CityElement: Codable, Identifiable {
    var id: UUID { UUID() }
    let name: String
    let lat, lon: Double
    let country: String
    let state: String?

    enum CodingKeys: String, CodingKey {
        case name
        case lat, lon, country, state
    }
}
