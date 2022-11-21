import Foundation
import CoreLocation

struct WeatherModel: Decodable {
  let lat, lon: Double
  let timezone: String
  let timezoneOffset: Int
  let current: CurrentWeather
  let hourly: [CurrentWeather]
  let daily: [DailyWeatherModel]
  
  enum CodingKeys: String, CodingKey {
    case lat, lon, timezone
    case timezoneOffset = "timezone_offset"
    case current, hourly, daily
  }
  
  var coordinate: CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: lat, longitude: lon)
  }
}
