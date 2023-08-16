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
               predicate: NSPredicate? = nil) async -> Result<[Entity], Error> {
        await context.perform {
            let request = Entity.fetchRequest()
            request.sortDescriptors = sortDescriptors
            request.predicate = predicate
            do {
                guard let results = try self.context.fetch(request) as? [Entity] else {
                    return .failure(RepositoryError.objectNotFound)
                }
                return .success(results)
            } catch {
                return .failure(error)
            }
        }
    }

    func object(_ id: NSManagedObjectID) async -> Result<Entity, Error> {
        await context.perform {
           guard let entity = try? self.context.existingObject(with: id) as? Entity else {
               return .failure(RepositoryError.objectNotFound)
           }
           return .success(entity)
        }
    }
    
    func doesObjectExist(_ predicate: NSPredicate) async -> Bool {
        await context.perform {
            let request = Entity.fetchRequest()
            request.predicate = predicate
            do {
                let count = try self.context.count(for: request)
                return Int(count) > 0
            } catch {
                return false
            }
        }
    }
    
    func add(_ body: @escaping (inout Entity) -> Void) async -> Result<Entity, Error> {
        await context.perform {
            var entity = Entity(context: self.context)
            body(&entity)
            do {
                try self.context.save()
                return .success(entity)
            } catch {
                return .failure(error)
            }
        }
    }
    
    func update(_ entity: Entity) async -> Result<Void, Error> {
        await context.perform {
            do {
                try self.context.save()
                return .success(())
            } catch {
                return .failure(error)
            }
        }
    }
    
    func delete(_ entity: Entity) async -> Result<Void, Error> {
        await context.perform {
                do {
                    self.context.delete(entity)
                    try self.context.save()
                    return .success(())
                } catch {
                    return .failure(error)
                }
        }
    }
    
    // MARK: - Private

    private var persistentContainer: NSPersistentContainer = {
          let container = NSPersistentContainer(name: "WeatherApp")
          container.loadPersistentStores(completionHandler: { (_, error) in
              if let error = error as NSError? {
                  fatalError("Unresolved error \(error), \(error.userInfo)")
              }
          })
          return container
      }()
}
