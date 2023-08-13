import Foundation
import CoreLocation

struct City: Decodable, Identifiable, Equatable {
    
    var id: String { "\(lat)\(lon)" }
    let name: String
    let lat, lon: Double
    let country: String
    let state: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case lat, lon, country, state
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }

    init(_ model: CityEntity) {
        self.name = model.name ?? ""
        self.lat = model.coordinate?.lat ?? 0
        self.lon = model.coordinate?.lon ?? 0
        self.country = model.country ?? ""
        self.state = model.state
    }
    
    func setUpEntity(_ cityEntity: CityEntity, _ coordinate: CoordinateEntity) {
        cityEntity.id = UUID(uuidString: id)
        coordinate.lat = lat.round(to: 3)
        coordinate.lon = lon.round(to: 3)
        cityEntity.coordinate = coordinate
        cityEntity.name = name
        cityEntity.country = country
        cityEntity.state = state
        cityEntity.cityID = Int64(HashService.getHash(from: lat.round(to: 3),
                                                      and: lon.round(to: 3)))
        print(lat.round(to: 3), lon.round(to: 3))
        print("City entity 🏙️", cityEntity.cityID)
    }
}
