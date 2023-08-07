import Foundation

class CityCoreDataService {
    
    // MARK: Properties
    
    private let dataController: CoreDataController
    
    init(dataController: CoreDataController) {
        self.dataController = dataController
    }
    
    // MARK: Public
    
    func save(_ model: City) {
        let cityEntity = CityEntity(context: dataController.context)
        let coordinateEntity = CoordinateEntity(context: dataController.context)
        model.setUpEntity(cityEntity, coordinateEntity)
        dataController.saveContext()
    }
    
    func fetch(by cityName: String) throws -> [City] {
        let fetchRequest = CityEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name = %@", cityName)
        
        do {
            let objects = try dataController.context.fetch(fetchRequest)
            let cities = objects.compactMap { City($0) }
            return cities
        } catch {
            throw error
        }
    }
}
