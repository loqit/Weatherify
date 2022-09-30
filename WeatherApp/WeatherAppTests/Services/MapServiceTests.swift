import XCTest
@testable import WeatherApp
import CoreLocation

class MapServiceTests: XCTestCase {
    
    let mapService = MapService(locationManager: LocationManager())
    
    let firstCoordinate = CLLocationCoordinate2D(latitude: 42.3554334, longitude: -71.060511)
    let secondCoordinate = CLLocationCoordinate2D(latitude: 38.0, longitude: -97.0)
    
    func testDistance() {
        let distance = mapService.getDistance(between: firstCoordinate, and: secondCoordinate)
        XCTAssertEqual(distance, 2252236.233435793)
    }
    
    func testDestination() {
        mapService.configureDestinationLocation(by: firstCoordinate)
        let coordinate = mapService.mapView.annotations[0].coordinate
        XCTAssertEqual(coordinate.longitude, firstCoordinate.longitude)
        XCTAssertEqual(coordinate.latitude, firstCoordinate.latitude)
    }

}
