import Foundation
import CoreLocation

struct CountryElement: Decodable, Identifiable, Equatable {

    var id: String { "\(latlng[0])\(latlng[1])" }
    let name: Name
    let flags: CoatOfArms
    let capital: [String]?
    let latlng: [Double]
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latlng[0], longitude: latlng[1])
    }
}
