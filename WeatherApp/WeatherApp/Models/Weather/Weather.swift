import Foundation

struct Weather: Decodable {
  let id: Int
  let main: String
  let weatherDescription: String
  let icon: String
  
  enum CodingKeys: String, CodingKey {
    case id, main
    case weatherDescription = "description"
    case icon
  }
  
  init(_ model: WeatherEntity?) {
    self.id = Int(model?.id ?? 0)
    self.main = model?.main ?? ""
    self.weatherDescription = model?.weatherDescription ?? ""
    self.icon = model?.icon ?? ""
  }
  
  func saveAsEntity(_ dataController: DataController) -> WeatherEntity {
    let weatherEnity = WeatherEntity(context: dataController.context)
    weatherEnity.id = Int64(self.id)
    weatherEnity.main = self.main
    weatherEnity.icon = self.icon
    weatherEnity.weatherDescription = self.weatherDescription
    return weatherEnity
  }
}
