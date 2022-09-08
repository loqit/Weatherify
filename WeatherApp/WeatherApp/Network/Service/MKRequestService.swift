import Foundation
import MapKit

protocol MKRequestServiceProtocol {
    func configureDirectionRequest(from source: MKMapItem,
                                   to destination: MKMapItem,
                                   using transportType: MKDirectionsTransportType) -> MKDirections
}

class MKRequestService: MKRequestServiceProtocol {
    func configureDirectionRequest(from source: MKMapItem,
                                   to destination: MKMapItem,
                                   using transportType: MKDirectionsTransportType) -> MKDirections {
        let request = MKDirections.Request()
        request.source = source
        request.destination = destination
        request.transportType = transportType
        let directions = MKDirections(request: request)
        return directions
    }
}
