import Foundation
import CoreLocation

struct WeatherModel: Decodable {
  let lat, lon: Double
  let timezone: String
  let current: CurrentWeather
  var hourly: [CurrentWeather]
  var daily: [DailyWeatherModel]
  
  enum CodingKeys: String, CodingKey {
    case lat, lon, timezone
    case current, hourly, daily
  }
  
  var coordinate: CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: lat, longitude: lon)
  }
  
  init(_ model: WeatherDataEntity) {
    self.lat = model.lat
    self.lon = model.lon
    self.timezone = model.timezone ?? ""
    self.current = CurrentWeather(model.current)

    model.hourly.do { hourly in
      self.hourly = hourly.compactMap { CurrentWeather($0 as? CurrentWeatherEntity) }
    }
    model.daily.do { daily in
      self.daily = daily.compactMap { DailyWeatherModel($0 as? DailyWeatherEntity) }
    }
  }
}
