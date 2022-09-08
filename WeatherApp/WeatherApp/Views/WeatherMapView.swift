import SwiftUI
import MapKit
import Combine

struct WeatherMapView: View {

    var name: String
    @State var mapView = MapView()
    
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
    
    func makeUIView(context: Context) -> MKMapView {
        return mapService.mapView
    }
    
    func drawRoute(by name: String) {
        mapService.drawRoute(by: name)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {}
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherMapView(name: "USA")
    }
}
