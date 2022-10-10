import Foundation

struct City: Decodable, Identifiable {
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
