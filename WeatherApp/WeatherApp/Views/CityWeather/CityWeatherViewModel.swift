import Foundation
import Combine
import CoreLocation

final class CityWeatherViewModel: ObservableObject {
    @Published var coordinate: CLLocationCoordinate2D
    @Published var cityName: String
    @Published var country: String

    init(coordinate: CLLocationCoordinate2D, cityName: String, country: String) {
        self.coordinate = coordinate
        self.cityName = cityName
        self.country = country
    }
    
    init(city: City) {
        self.coordinate = city.coordinate
        self.cityName = city.name
        self.country = city.country
    }
}
