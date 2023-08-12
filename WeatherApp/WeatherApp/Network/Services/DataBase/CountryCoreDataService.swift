import Foundation

actor CountryCoreDataService {
    
    // MARK: - Properties

    let dataController: CoreDataController
    
    init(dataController: CoreDataController) {
        self.dataController = dataController
    }
    
    // MARK: - Public

    func save(_ model: CountryElement) {
        let country = CountryEntity(context: dataController.context)
        
        country.name?.common = model.name.common
        country.name?.official = model.name.official
        country.coatOfArms?.png = model.flags.png
        country.coatOfArms?.svg = model.flags.svg
        
        dataController.saveContext()
    }
    
    func delete(by id: UUID) {
        let fetchRequest = dataController.createFetchRequest(by: id)
        do {
            let objects = try dataController.context.fetch(fetchRequest)
            for object in objects {
                dataController.context.delete(object)
            }
        } catch _ {
            print("Failed fetching")
        }
        dataController.saveContext()
    }
}
