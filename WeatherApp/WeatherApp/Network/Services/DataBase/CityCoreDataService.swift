import Foundation

class CityCoreDataService {

  // MARK: Properties
  
  private let dataController: DataController
  
  init(dataController: DataController) {
    self.dataController = dataController
  }
  
  // MARK: Public
  
  func save(_ model: City) {
    _ = model.saveAsEntity(dataController)
    dataController.saveContext()
  }
  
  func fetch(by cityName: String) throws -> [City] {
    let fetchRequest = CityEntity.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "name = %@", cityName)
    
    do {
      let objects = try dataController.context.fetch(fetchRequest)
      let cities = objects.compactMap { City($0) }
      print("City 🏙️", cities)
      return cities
    } catch {
      throw error
    }
  }
  
  // MARK: Private
}
