import Foundation

struct CurrentWeather: Decodable, Identifiable {
  var id: UUID { UUID() }
  let daytime: Double
  let sunrise, sunset: Int?
  let temp, feelsLike: Double
  let pressure: Int
  let dewPoint, uvi: Double
  let clouds, visibility: Int
  let windSpeed: Double
  let windDeg: Int
  let weather: [Weather]
  let windGust, pop: Double?
  
  enum CodingKeys: String, CodingKey {
    case daytime = "dt"
    case sunrise, sunset, temp
    case feelsLike = "feels_like"
    case pressure
    case dewPoint = "dew_point"
    case uvi, clouds, visibility
    case windSpeed = "wind_speed"
    case windDeg = "wind_deg"
    case weather
    case windGust = "wind_gust"
    case pop
  }
}
