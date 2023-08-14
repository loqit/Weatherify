import Foundation
import CoreLocation

struct WeatherModel: Decodable, Equatable {

    let lat, lon: Double
    let timezone: String
    let current: CurrentWeather
    var hourly: [CurrentWeather]
    var daily: [DailyWeatherModel]

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }

    enum CodingKeys: String, CodingKey {

        case lat, lon, timezone
        case current, hourly, daily
    }
}
