import Foundation
import CoreData

//protocol DataBaseProtocol: Actor {
//  associatedtype Model
//
//  func save(element: Model)
//  func delete(by id: UUID)
//  func update(model: Model, by id: UUID)
//  func get(by id: UUID)
//}

actor CountryCoreDataService {
  
  let dataController: DataController?
  
  init(dataController: DataController) {
    self.dataController = dataController
  }
  
  func save(by name: String, and id: UUID) {
    guard let context = dataController?.context else {
      print("Context error ")
      return
    }
    let country = CountryEntity(context: context)
    print("\(name) 🤢")
    country.name = name
    country.id = id
    dataController?.saveContext()
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

//actor CoreDataService {
//
//  let dataController: DataController?
//
//  init(dataController: DataController) {
//    self.dataController = dataController
//  }
//
//  func save<T>(model T, by entityName: String) {
//    guard let context = dataController?.context else {
//      print("Context error ")
//      return
//    }
//    let modelEntity = CountryEntity(context: context)
//    country.name = name
//    country.id = id
//    do {
//      try context.save()
//    } catch {
//      print("Saving Error 🤡")
//    }
//  }
//}
