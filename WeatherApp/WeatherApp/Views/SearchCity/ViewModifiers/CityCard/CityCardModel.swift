import Foundation
import Combine

final class CityCardModel: ObservableObject {
    @Published var cityName: String
    @Published var cityState: String
    @Published var cityCountry: String
    @Published var cityID: String

    init(cityName: String, cityState: String, cityCountry: String, cityID: String) {
        self.cityName = cityName
        self.cityState = cityState
        self.cityCountry = cityCountry
        self.cityID = cityID
    }

    convenience init(city: City) {
        self.cityName = city.name
        self.cityState = city.state
        self.cityCountry = city.country
        self.cityID = city.id
    }
}
