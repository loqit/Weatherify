import Foundation
import CoreLocation

struct City: Decodable, Identifiable, Equatable {
    
    var id: String { "\(lat)\(lon)" }
    let name: String
    let lat, lon: Double
    let country: String
    let state: String?

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }

    enum CodingKeys: String, CodingKey {

        case name
        case lat, lon, country, state
    }
}
