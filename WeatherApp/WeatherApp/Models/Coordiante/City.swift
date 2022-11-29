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
  
  func setUpEntity(_ cityEntity: CityEntity) {
    cityEntity.id = id
    cityEntity.lat = lat.round(to: 3)
    cityEntity.lon = lon.round(to: 3)
    cityEntity.name = name
    cityEntity.country = country
    cityEntity.state = state
    cityEntity.cityID = Int64(HashService.getHash(from: lat.round(to: 3),
                                                  and: lon.round(to: 3)))
    print(lat.round(to: 3), lon.round(to: 3))
    print("City entity 🏙️", cityEntity.cityID)
  }
}
