import Foundation
import MapKit

protocol MKRequestServiceProtocol {
    
    func configureDirectionRequest(from source: CLLocationCoordinate2D,
                                   to destination: CLLocationCoordinate2D,
                                   using transportType: MKDirectionsTransportType) -> MKDirections
}
