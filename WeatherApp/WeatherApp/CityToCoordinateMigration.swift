import CoreData

class CityToCoordinateMigration: NSEntityMigrationPolicy {
  override func createDestinationInstances(forSource sInstance: NSManagedObject,
                                           in mapping: NSEntityMapping,
                                           manager: NSMigrationManager) throws {
    let lat = sInstance.primitiveValue(forKey: "lat") as? Double
    let lon = sInstance.primitiveValue(forKey: "lon") as? Double
    let coordinate = NSEntityDescription.insertNewObject(forEntityName: "CoordinateEntity",
                                                         into: manager.destinationContext)
    coordinate.setValue(lat, forKey: "lat")
    coordinate.setValue(lon, forKey: "lon")
    let entities = manager.destinationInstances(forEntityMappingName: mapping.name,
                                                sourceInstances: [sInstance])
    print("Entities", entities)
    if let destEntity = entities.last {
      print("destEntity :", destEntity)
      destEntity.setValue(coordinate, forKey: "coordinate")
    }
  }
}
