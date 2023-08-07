import SwiftUI
import MapKit
import Combine

struct WeatherMapView: View {
    
    var coordinate: CLLocationCoordinate2D
    @State var mapView = MapView()
    
    var body: some View {
        mapView
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                mapView.updateMap(with: coordinate)
            }
        Button {
            mapView.drawRoute()
        } label: {
            Text("Draw Route")
        }
    }
}

struct MapView: UIViewRepresentable {

    typealias UIViewType = MKMapView
    
    private var mapService = MapService(locationManager: LocationManager())
    
    func makeUIView(context: Context) -> MKMapView {
        return mapService.mapView
    }
    
    func drawRoute() {
        mapService.drawRoute()
    }
    
    func updateMap(with coordinate: CLLocationCoordinate2D) {
        mapService.configureDestinationLocation(by: coordinate)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {}
}
