import SwiftUI
import MapKit

struct MapView: View {
    
    var name: String
    @State var region = MKCoordinateRegion()

    var body: some View {
        Map(coordinateRegion: $region)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                let searchRequest = MKLocalSearch.Request()
                searchRequest.naturalLanguageQuery = name
                let search = MKLocalSearch(request: searchRequest)
                search.start { response, error in
                    guard let response = response else {
                        print("Error: \(error?.localizedDescription ?? "Unknown error").")
                        return
                    }
                    
                    setRegion(with: response.boundingRegion)
                }
            }
    }
    private func setRegion(with region: MKCoordinateRegion) {
        self.region = region
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(name: "USA")
    }
}
