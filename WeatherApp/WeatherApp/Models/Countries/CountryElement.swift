import Foundation
import CoreLocation

struct CountryElement: Decodable, Identifiable, Equatable {

    var id: String { "\(coordinate.latitude)\(coordinate.longitude)" }
    let name: Name
    let flags: CoatOfArms
    let capital: [String]?
    let latlng: [Double]
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latlng[0], longitude: latlng[1])
    }

    static func == (lhs: CountryElement, rhs: CountryElement) -> Bool {
        lhs.id == rhs.id
    }
}
