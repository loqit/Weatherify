import Foundation
import Combine
import CoreData

class CoreDataController<Entity: NSManagedObject> {
    
    // MARK: - Properties

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Public
    
    func fetch(sortDescriptors: [NSSortDescriptor] = [],
               predicate: NSPredicate? = nil)
    -> AnyPublisher<[Entity], Error> {
        Future { [context] promise in
            context.perform {
                let request = Entity.fetchRequest()
                request.sortDescriptors = sortDescriptors
                request.predicate = predicate
                do {
                    guard let results = try context.fetch(request) as? [Entity] else {
                        promise(.failure(RepositoryError.objectNotFound))
                        return
                    }
                    promise(.success(results))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func object(_ id: NSManagedObjectID) -> AnyPublisher<Entity, Error> {
        Future { [context] promise in
            context.perform {
                guard let entity = try? context.existingObject(with: id) as? Entity else {
                    promise(.failure(RepositoryError.objectNotFound))
                    return
                }
                promise(.success(entity))
            }
            
        }
        .eraseToAnyPublisher()
    }
    
    func add(_ body: @escaping (inout Entity) -> Void) -> AnyPublisher<Entity, Error> {
        Future { [context] promise in
            context.perform {
                var entity = Entity(context: context)
                body(&entity)
                do {
                    try context.save()
                    promise(.success(entity))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func update(_ entity: Entity) -> AnyPublisher<Void, Error> {
        Future { [context] promise in
            context.perform {
                do {
                    try context.save()
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func delete(_ entity: Entity) -> AnyPublisher<Void, Error> {
        Future { [context] promise in
            context.perform {
                do {
                    context.delete(entity)
                    try context.save()
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Private

    private var persistentContainer: NSPersistentContainer = {
          let container = NSPersistentContainer(name: "WeatherApp")
          container.loadPersistentStores(completionHandler: { (storeDescription, error) in
              if let error = error as NSError? {
                  fatalError("Unresolved error \(error), \(error.userInfo)")
              }
          })
          return container
      }()
}
