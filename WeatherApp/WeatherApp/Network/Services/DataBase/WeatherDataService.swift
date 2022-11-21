import Foundation

actor WeatherDataService {

  // MARK: - Properties
  private var dataController: DataController?
  
  init(dataController: DataController) {
    self.dataController = dataController
  }
  
  // MARK: - Public
  
  func save(_ data: WeatherModel) {
    guard let dataController = dataController else {
      return
    }
    let weatherDataEntity = WeatherDataEntity(context: dataController.context)
    // Save data
    weatherDataEntity.id = UUID()
    weatherDataEntity.lon = data.lon
    weatherDataEntity.lat = data.lat
    
    weatherDataEntity.current?.daytime = data.current.daytime
    weatherDataEntity.current?.temp = data.current.daytime
    weatherDataEntity.current?.weather?.icon = data.current.weather[0].icon
    
    weatherDataEntity.hourly?.daytime = data.hourly[0].daytime
    weatherDataEntity.hourly?.temp = data.hourly[0].daytime
    weatherDataEntity.hourly?.weather?.icon = data.hourly[0].weather[0].icon
    
    dataController.saveContext()
  }
  
  func get(by id: UUID) {
    
  }
  
  // MARK: - Private

}
