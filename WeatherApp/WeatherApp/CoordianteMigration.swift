import Foundation
import CoreData

class CoordinateMigration: NSEntityMigrationPolicy {

  override func createDestinationInstances(forSource sInstance: NSManagedObject,
                                           in mapping: NSEntityMapping,
                                           manager: NSMigrationManager) throws {
    if sInstance.entity.name == "WeatherDataEntity" || sInstance.entity.name == "CityEntity" {
      let lat = sInstance.primitiveValue(forKey: "lat") as? Double
      let lon = sInstance.primitiveValue(forKey: "lon") as? Double
      let coordinate = NSEntityDescription.insertNewObject(forEntityName: "CoordinateEntity",
                                                           into: manager.destinationContext)
      coordinate.setValue(lat, forKey: "lat")
      coordinate.setValue(lon, forKey: "lon")
    
      print("sInstance :", sInstance)
      print("sInstance.entity :", sInstance.entity)
      print("mapping : ", mapping)
      print("mapping name: ", mapping.name)
     // let entity = NSEntityDescription.insertNewObject(forEntityName: mapping.name, into: manager.destinationContext)
      let entity = manager.destinationInstances(forEntityMappingName: mapping.name, sourceInstances: [sInstance])
      print("Entities", entity)
      if let destEntity = entity.last {
        print("destEntity :", destEntity)
        destEntity.setValue(coordinate, forKey: "coordinate")
      }
      
//      let destRes = manager.destinationInstances(forEntityMappingName: mapping.name, sourceInstances: [sInstance])
//      if let destEntity = destRes.last {
//        destEntity.setValue(coordinate, forKey: "coordinate")
//      }
    }
  }
}
