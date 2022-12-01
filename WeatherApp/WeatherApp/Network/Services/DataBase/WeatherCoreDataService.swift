import Foundation

class WeatherCoreDataService {

  // MARK: Properties
  private let dataController: CoreDataController
  
  init(dataController: CoreDataController) {
    self.dataController = dataController
  }
  
  // MARK: Public
  
  func save(_ model: WeatherModel?, _ lat: Double, _ lon: Double) {
    model.do { model in
      _ = model.saveAsEntity(dataController, lat, lon)
      dataController.saveContext()
    }
  }
  
  @MainActor
  func fetch(by cityID: Int) throws -> WeatherModel {
    let fetchRequest = WeatherDataEntity.fetchRequest()
    print(cityID)
    fetchRequest.predicate = NSPredicate(format: "cityID = %d", cityID) // %@ shouldn't be used with an int, use %d instead.
    
    do {
      let object = try dataController.context.fetch(fetchRequest).first
      let weatherData = WeatherModel(object)
      print("Weather data 🌎", weatherData)
      return weatherData
    } catch {
      throw error
    }
  }
}
