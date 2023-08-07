import Foundation
import MapKit
import CoreLocation

protocol MapServiceType: MKMapViewDelegate {

    var locationManager: LocationManager { get set }
    func configureDestinationLocation(by coordinate: CLLocationCoordinate2D)
    func drawRoute()
}
