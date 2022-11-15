import Foundation
import CoreData

class DataController: ObservableObject {
  
  // MARK: - Properties
  var context: NSManagedObjectContext {
    return Self.container.viewContext
  }
  
  // MARK: - Public
  func saveContext() {
    do {
      try context.save()
    } catch {
      print("Failed saving context 😧")
    }
  }
  
  func createFetchRequest<T: NSManagedObject>(by id: UUID) -> NSFetchRequest<T> { // 
    let fetchRequest: NSFetchRequest<T> = NSFetchRequest(entityName: NSStringFromClass(T.self))
    fetchRequest.predicate = NSPredicate(format: "id==\(id)")
    return fetchRequest
  }
  
  // MARK: - Private
  private static var container: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "WeatherApp")
    container.loadPersistentStores { _, error in
      if let error = error {
        fatalError("Unable to load persistent stores: \(error)")
      }
    }
    return container
  }()
}
