import Foundation
import MapKit

struct MapPoint: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}
