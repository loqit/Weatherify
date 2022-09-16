import Foundation
import MapKit

class MapService: NSObject, MKMapViewDelegate {
    
    private(set) var mapView = MKMapView()
    private var requestService: MKRequestServiceProtocol
    var locationManager: LocationManager
    
    struct Constants {
        static let delta: Double = 5000
    }
    
    private(set) var isDrawing = false
    
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        self.requestService = MKRequestService()
        super.init()
        mapView.delegate = self
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .systemRed
        renderer.lineWidth = 5
        return renderer
    }
    
    private func configureSourceLocation() {
        locationManager.requestLocation()
        guard let source = locationManager.location else {
            return
        }
        self.addAnnotation(source)
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
      //  let ann = MKPlacemark(coordinate: coordinate)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        mapView.addAnnotation(annotation)
    }

    func drawRoute() { // [MapItem]
        isDrawing = true
        configureSourceLocation()
        for index in 0..<mapView.annotations.count - 1 {
            let direction = requestService.configureDirectionRequest(from: mapView.annotations[index],
                                                                     to: mapView.annotations[index + 1],
                                                                     using: .automobile)
            calculateRoute(using: direction)
        }
    }

    private func calculateRoute(using directions: MKDirections) {
        directions.calculate { response, _ in
            guard let route = response?.routes.first else {
                return
            }
            self.mapView.addOverlay(route.polyline)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect,
                                           edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
                                           animated: true)
            self.isDrawing = false
        }
    }
}
