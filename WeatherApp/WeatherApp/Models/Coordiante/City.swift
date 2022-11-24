import Foundation

struct City: Decodable, Identifiable {
  var id: UUID { UUID() }
  let name: String
  let lat, lon: Double
  let country: String
  let state: String?
  
  enum CodingKeys: String, CodingKey {
    case name
    case lat, lon, country, state
  }
  
  init(_ model: CityEntity) {
    self.name = model.name ?? ""
    self.lat = model.lat
    self.lon = model.lon
    self.country = model.country ?? ""
    self.state = model.state
  }
  
  func saveAsEntity(_ dataController: DataController) -> CityEntity {
    let cityEntity = CityEntity(context: dataController.context)
    cityEntity.lat = self.lat
    cityEntity.lon = self.lon
    cityEntity.name = self.name
    cityEntity.country = self.country
    cityEntity.state = self.state
    cityEntity.cityID = Int64(HashService.getHash(from: self.lat,
                                                  and: self.lon))
    return cityEntity
  }
}
