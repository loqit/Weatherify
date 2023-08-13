import Foundation

class WeatherCoreDataService {
    
    // MARK: Properties

    private let dataController: CoreDataController
    
    init(dataController: CoreDataController) {
        self.dataController = dataController
    }
    
    // MARK: Public
    
    func save(_ model: WeatherModel?) {
        model.do { model in
            _ = model.saveAsEntity(dataController)
            dataController.saveContext()
        }
    }
    
    @MainActor
    func fetch(by cityID: Int) throws -> WeatherModel {
        let fetchRequest = WeatherDataEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "cityID = %d", cityID)
        
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
