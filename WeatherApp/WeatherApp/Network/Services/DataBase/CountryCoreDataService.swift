import Foundation

actor CountryCoreDataService {
  
  let dataController: DataController?
  
  init(dataController: DataController) {
    self.dataController = dataController
  }
  
  func save(_ model: CountryElement) {
    guard let dataController = dataController else {
      return
    }
    
    let country = CountryEntity(context: dataController.context)
    print("\(model.name.common) 🤢")
    
    country.name?.common = model.name.common
    country.name?.official = model.name.official
    country.id = model.id
    country.latlng = model.latlng
    country.coatOfArms?.png = model.flags.png
    country.coatOfArms?.svg = model.flags.svg
    
    dataController.saveContext()
  }
  
  func delete(by id: UUID) {
    guard let dataController = dataController else {
      return
    }

    let fetchRequest = dataController.createFetchRequest(by: id)
    do {
      let objects = try dataController.context.fetch(fetchRequest)
      for object in objects {
        dataController.context.delete(object)
      }
    } catch _ {
      print("Failed fetching 🤡")
    }
    dataController.saveContext()
  }
  
//  func get(by id: UUID) -> CountryEntity? {
//    guard let dataController = dataController else {
//      return nil
//    }
//
//    let fetchRequest = dataController.createFetchRequest(by: id)
//    do {
//      let objects = try dataController.context.fetch(fetchRequest)
//      for object in objects {
//        dataController.context.delete(object)
//      }
//    } catch _ {
//      print("Failed fetching 🤡")
//    }
//
//  }
  
  func update(by id: UUID, with model: CountryElement) {
    
  }
}
