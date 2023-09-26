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
    
    init(_ model: CityEntity) {
        self.name = model.name ?? ""
        self.lat = model.coordinate?.lat ?? 0
        self.lon = model.coordinate?.lon ?? 0
        self.country = model.country ?? ""
        self.state = model.state
    }
    
    init(name: String,
         lat: Double,
         lon: Double,
         country: String,
         state: String?) {
        self.name = name
        self.lat = lat
        self.lon = lon
        self.country = country
        self.state = state
    }
}
