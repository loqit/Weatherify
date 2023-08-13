import Foundation
import MapKit

class MapService: NSObject, MapServiceType {
    
    // MARK: - Properties
    
    private var sourceLocation = CLLocationCoordinate2D()
    private var destinationLocation = CLLocationCoordinate2D()

    private(set) var mapView = MKMapView()
    private var requestService: MKRequestServiceProtocol
    var locationManager: LocationManager
    
    struct Constants {
        static let delta: Double = 5000
    }

    // MARK: - Init

    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        requestService = MKRequestService()
        super.init()
        mapView.delegate = self
    }
    
    // MARK: - Public

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .systemRed
        renderer.lineWidth = 5
        return renderer
    }
    
    func getDistance(between source: CLLocationCoordinate2D,
                     and destination: CLLocationCoordinate2D
    ) -> CLLocationDistance {
        let sourceLoc = CLLocation(latitude: source.latitude,
                                   longitude: source.longitude)
        let destLoc = CLLocation(latitude: destination.latitude,
                                 longitude: destination.longitude)
        
        let distance = destLoc.distance(from: sourceLoc)
        return distance
    }
    
    func configureDestinationLocation(by coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate,
                                        latitudinalMeters: Constants.delta,
                                        longitudinalMeters: Constants.delta)
        mapView.setRegion(region, animated: true)
        addAnnotation(coordinate)
    }

    func addAnnotation(_ coordinate: CLLocationCoordinate2D,
                       _ title: String? = nil) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        mapView.addAnnotation(annotation)
    }

    func drawRoute() {
        configureSourceLocation()
        let direction = requestService.configureDirectionRequest(from: sourceLocation,
                                                                 to: destinationLocation,
                                                                 using: .automobile)
        calculateRoute(using: direction)
        
    }
    
    // MARK: - Private

    private func calculateRoute(using directions: MKDirections) {
        directions.calculate { response, _ in
            guard let route = response?.routes.first else {
                return
            }
            self.mapView.addOverlay(route.polyline)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect,
                                           edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
                                           animated: true)
        }
    }
    
    private func configureSourceLocation() {
        locationManager.requestLocation()
        guard let source = locationManager.location else {
            return
        }
        addAnnotation(source)
    }
}
