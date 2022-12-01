import Foundation

struct CurrentWeather: Decodable, Identifiable, EntityComparable {
  
  typealias Entity = CurrentWeatherEntity
  
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
  
  func saveAsEntity(_ dataController: CoreDataController) -> CurrentWeatherEntity {
    let currentWeatherEntity = CurrentWeatherEntity(context: dataController.context)
    currentWeatherEntity.id = id
    currentWeatherEntity.daytime = daytime
    currentWeatherEntity.temp = temp
    currentWeatherEntity.weather = NSSet(array: weather.compactMap { $0.saveAsEntity(dataController) })
    return currentWeatherEntity
  }
}
