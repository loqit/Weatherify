import Foundation
import CoreData

class CoreDataController: ObservableObject {
  
  // MARK: - Properties
  var context: NSManagedObjectContext {
    return Self.container.viewContext
  }
  
  // MARK: - Public
  func saveContext() {
    do {
      try context.save()
    } catch {
      print(error)
      print("Failed saving context 😧")
    }
  }
  
  func createFetchRequest<T: NSManagedObject>(by id: UUID) -> NSFetchRequest<T> {
    let fetchRequest: NSFetchRequest<T> = NSFetchRequest(entityName: NSStringFromClass(T.self))
    fetchRequest.predicate = NSPredicate(format: "id==\(id)")
    return fetchRequest
  }
  
  // MARK: - Private
  private static var container: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "WeatherApp")
    
    container.loadPersistentStores { _, error   in
      error.do { error in
        fatalError("Unable to load persistent stores: \(error)")
      }
      let description = NSPersistentStoreDescription()
      description.shouldMigrateStoreAutomatically = false
      description.shouldInferMappingModelAutomatically = true
      container.persistentStoreDescriptions = [description]
    }
    return container
  }()
}
