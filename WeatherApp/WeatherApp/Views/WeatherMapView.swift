import SwiftUI
import MapKit
import Combine

struct WeatherMapView: View {

    var name: String
    @State var mapView = MapView()
    let coordinate = CLLocationCoordinate2D(latitude: 37.5407246, longitude: -77.4360481)
    
    var body: some View {
        mapView
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                mapView.drawRoute(by: name)
            }
    }
}

struct MapView: UIViewRepresentable {
    typealias UIViewType = MKMapView
    
    var mapService = MapService(locationManager: LocationManager())
    let coordinate = CLLocationCoordinate2D(latitude: 39.952583, longitude: -75.165222)
    
    func makeUIView(context: Context) -> MKMapView {
        return mapService.mapView
    }
    
    func drawRoute(by name: String) {
        mapService.addAnnotation(coordinate)
        mapService.drawRoute(by: name)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {}
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherMapView(name: "USA")
    }
}
