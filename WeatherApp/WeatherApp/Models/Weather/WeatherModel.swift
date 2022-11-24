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
  
  init(_ model: WeatherDataEntity?) {
    self.lat = model?.lat ?? 0
    self.lon = model?.lon ?? 0
    self.timezone = model?.timezone ?? ""
    self.current = CurrentWeather(model?.current)
    self.hourly = model?.hourly?.compactMap { CurrentWeather($0 as? CurrentWeatherEntity) } ?? []
    self.daily = model?.daily?.compactMap { DailyWeatherModel($0 as? DailyWeatherEntity) } ?? []
  }
  
  func saveAsEntity(_ dataController: DataController) -> WeatherDataEntity {
    let weatherDataEntity = WeatherDataEntity(context: dataController.context)
    weatherDataEntity.lat = self.lat
    weatherDataEntity.lon = self.lon
    weatherDataEntity.timezone = self.timezone
    weatherDataEntity.hourly = NSSet(array: self.hourly.compactMap { $0.saveAsEntity(dataController) })
    weatherDataEntity.daily = NSSet(array: self.daily.compactMap { $0.saveAsEntity(dataController) })
    return weatherDataEntity
  }
}
