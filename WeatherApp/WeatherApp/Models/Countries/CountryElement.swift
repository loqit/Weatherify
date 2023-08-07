import Foundation
import CoreLocation

struct CountryElement: Decodable, Identifiable {
    
    var id: UUID { UUID() }
    let name: Name
    let flags: CoatOfArms
    let capital: [String]?
    let latlng: [Double]
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latlng[0], longitude: latlng[1])
    }
}
