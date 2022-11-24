import Foundation

struct CurrentWeather: Decodable, Identifiable {
  var id: UUID { UUID() }
  let daytime: Double
  let temp: Double
  var weather: [Weather]
  
  enum CodingKeys: String, CodingKey {
    case daytime = "dt"
    case temp
    case weather
  }
  
  init(_ model: CurrentWeatherEntity?) {
    self.daytime = model?.daytime ?? 0
    self.temp = model?.temp ?? 0
    self.weather = model?.weather?.compactMap { Weather($0 as? WeatherEntity) } ?? []
  }
  
  func saveAsEntity(_ dataController: DataController) -> CurrentWeatherEntity {
    let currentWeatherEntity = CurrentWeatherEntity(context: dataController.context)
    currentWeatherEntity.daytime = self.daytime
    currentWeatherEntity.temp = self.temp
    currentWeatherEntity.weather = NSSet(array: self.weather.compactMap { $0.saveAsEntity(dataController) })
    return currentWeatherEntity
  }
}
