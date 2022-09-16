import Foundation
import MapKit

protocol MKRequestServiceProtocol {
    func configureDirectionRequest(from source: MKAnnotation,
                                   to destination: MKAnnotation,
                                   using transportType: MKDirectionsTransportType) -> MKDirections
}

class MKRequestService: MKRequestServiceProtocol {
    func configureDirectionRequest(from source: MKAnnotation,
                                   to destination: MKAnnotation,
                                   using transportType: MKDirectionsTransportType) -> MKDirections {
        let request = MKDirections.Request()
        let sourceItem = MKMapItem(placemark: MKPlacemark(coordinate: source.coordinate))
        let destinationItem = MKMapItem(placemark: MKPlacemark(coordinate: destination.coordinate))
        request.source = sourceItem
        request.destination = destinationItem
        request.transportType = transportType
        let directions = MKDirections(request: request)
        return directions
    }
}
