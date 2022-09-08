import Foundation
import MapKit

class MapService: NSObject, MKMapViewDelegate {
    
    private(set) var mapView = MKMapView()
    private var requestService: MKRequestServiceProtocol
    var locationManager: LocationManager
    
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        self.requestService = MKRequestService()
        super.init()
        mapView.delegate = self
        configureSourceLocation()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .systemRed
        renderer.lineWidth = 5
        return renderer
    }
    
    func configureSourceLocation() {
        let source = CLLocationCoordinate2D(latitude: CLLocationDegrees(40.730610),
                                            longitude: CLLocationDegrees(-73.935242))
        self.addAnnotation(source)
    }
    
    func drawRoute(by name: String) {
        locationManager.loadMap(by: name) { response, _ in
            guard let response = response else {
                return
            }
            self.mapView.setRegion(response.boundingRegion, animated: true)
            self.addAnnotation(response.boundingRegion.center)
            self.drawRoute()
        }
    }
    
    func addAnnotation(_ coordinate: CLLocationCoordinate2D) {
        let placemark = MKPlacemark(coordinate: coordinate)
        mapView.addAnnotation(placemark)
    }
    
    private func drawRoute() {
        for index in 0..<mapView.annotations.count - 1 {
            let sourcePlacemark = MKMapItem(placemark: MKPlacemark(coordinate: mapView.annotations[index].coordinate))
            let destinationPlacemark = MKMapItem(placemark: MKPlacemark(coordinate: mapView.annotations[index + 1].coordinate))
            
            let direction = requestService.configureDirectionRequest(from: sourcePlacemark,
                                                                     to: destinationPlacemark,
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
        }
    }
}
