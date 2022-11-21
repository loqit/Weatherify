import Foundation
import MapKit

protocol MKRequestServiceProtocol {
  func configureDirectionRequest(from source: CLLocationCoordinate2D,
                                 to destination: CLLocationCoordinate2D,
                                 using transportType: MKDirectionsTransportType) -> MKDirections
}

class MKRequestService: MKRequestServiceProtocol {
  func configureDirectionRequest(from source: CLLocationCoordinate2D,
                                 to destination: CLLocationCoordinate2D,
                                 using transportType: MKDirectionsTransportType) -> MKDirections {
    let request = MKDirections.Request()
    let sourceItem = MKMapItem(placemark: MKPlacemark(coordinate: source))
    let destinationItem = MKMapItem(placemark: MKPlacemark(coordinate: destination))
    request.source = sourceItem
    request.destination = destinationItem
    request.transportType = transportType
    let directions = MKDirections(request: request)
    return directions
  }
}
