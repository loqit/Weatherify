import SwiftUI
import MapKit
import Combine

struct WeatherMapView: View {
    
    // MARK: - Properties

    let coordinate: CLLocationCoordinate2D?
    @State private var mapView = MapView()
    
    // MARK: - Body

    var body: some View {
        ZStack {
            mapView
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    mapView.updateMap(with: coordinate)
                }
        }
        .toolbar(.hidden, for: .tabBar)
        .overlay(alignment: .bottom) {
            Button {
                mapView.drawRoute()
            } label: {
                FloatedButton(title: "Draw a route")
            }
        }
    }
}

struct MapView: UIViewRepresentable {

    typealias UIViewType = MKMapView
    
    private var mapService = MapService(locationManager: LocationManager())
    
    func makeUIView(context: Context) -> MKMapView {
        mapService.mapView
    }
    
    func drawRoute() {
        mapService.drawRoute()
    }
    
    func updateMap(with coordinate: CLLocationCoordinate2D?) {
        guard let coordinate = coordinate else {
            return
        }
        mapService.configureDestinationLocation(by: coordinate)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {}
}

struct WeatherMap_Previews: PreviewProvider {
    
    static var previews: some View {
        WeatherMapView(coordinate: CLLocationCoordinate2D(latitude: 53.893009,
                                                          longitude: 27.567444))
    }
}
