import Foundation

class CityCoreDataService {

  // MARK: Properties
  
  private let dataController: DataController
  
  init(dataController: DataController) {
    self.dataController = dataController
  }
  
  // MARK: Public
  
  func save(_ model: City) {
    let city = CityEntity(context: dataController.context)
    // Set properties
    city.name = model.name
    city.country = model.country
    city.id = model.id
    city.lat = model.lat
    city.lon = model.lon
    city.state = model.state
    city.cityID = Int64(HashService.getHash(from: model.lat,
                                             and: model.lon))

    // Save context
    dataController.saveContext()
  }
  
  func fetch(by cityName: String) throws -> City {
    let fetchRequest = CityEntity.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "name = %@", cityName)
    do {
      let object = try dataController.context.fetch(fetchRequest).first
      let cityElement = City(name: object?.name ?? "",
                             lat: object?.lat ?? 0,
                             lon: object?.lon ?? 0,
                             country: object?.country ?? "",
                             state: object?.state ?? "")
      print("City 🏙️", cityElement)
      return cityElement
    } catch {
      throw error
    }
  }
  
  // MARK: Private
}
