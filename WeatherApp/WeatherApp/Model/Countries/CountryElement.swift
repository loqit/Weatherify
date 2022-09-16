import Foundation
import CoreLocation

struct CountryElement: Codable, Identifiable {
    var id: UUID { UUID() }
    let name: Name
    let flags, coatOfArms: CoatOfArms
    let capital: [String]
    let latlng: [Double]
    
    func coordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latlng[0], longitude: latlng[1])
    }
}
