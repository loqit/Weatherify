import Foundation

struct DailyWeatherModel: Decodable, Identifiable {
  var id: UUID { UUID() }
  let daytime: Double
  let temp: Temperature
  var weather: [Weather]
  
  enum CodingKeys: String, CodingKey {
    case daytime = "dt"
    case temp
    case weather
  }
  
  init(_ model: DailyWeatherEntity?) {
    self.daytime = model?.daytime ?? 0
    self.temp = Temperature(model?.temp)
    self.weather = model?.weather?.compactMap { Weather($0 as? WeatherEntity) } ?? []
  }
  
  func saveAsEntity(_ dataController: DataController) -> DailyWeatherEntity {
    let dailyEntity = DailyWeatherEntity(context: dataController.context)
    dailyEntity.daytime = self.daytime
    dailyEntity.temp = self.temp.saveAsEntity(dataController)
    dailyEntity.weather = NSSet(array: self.weather.compactMap { $0.saveAsEntity(dataController) } )
    return dailyEntity
  }
}
