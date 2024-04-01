import Foundation
import Combine
import CoreLocation

final class CityWeatherViewModel: ObservableObject {
    @Published var coordinate: CLLocationCoordinate2D
    @Published var cityName: String

    init(coordinate: CLLocationCoordinate2D, cityName: String) {
        self.coordinate = coordinate
        self.cityName = cityName
    }
    
    init(city: City) {
        self.coordinate = city.coordinate
        self.cityName = city.name
    }
}
