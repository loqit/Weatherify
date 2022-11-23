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
    model?.weather.do { weather in
      self.weather = weather.compactMap { Weather($0 as? WeatherEntity) }
    }
  }
}
