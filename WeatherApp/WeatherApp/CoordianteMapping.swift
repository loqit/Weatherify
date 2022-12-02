import Foundation
import CoreData

class CoordinateMigration: NSEntityMigrationPolicy {

  override func createDestinationInstances(forSource sInstance: NSManagedObject,
                                           in mapping: NSEntityMapping,
                                           manager: NSMigrationManager) throws {

//    if sInstance.entity.name == "CountryEntity" {
//      let latlng = sInstance.primitiveValue(forKey: "latlng") as! [Double]
//      setUpCoordinate(latlng[0], latlng[1], manager: manager)
//    }
    
    if sInstance.entity.name == "WeatherDataEntity" || sInstance.entity.name == "CityEntity" {
      let lat = sInstance.primitiveValue(forKey: "lat") as? Double
      let lon = sInstance.primitiveValue(forKey: "lon") as? Double
      let coordinate = NSEntityDescription.insertNewObject(forEntityName: "CoordinateEntity",
                                                           into: manager.destinationContext)
      coordinate.setValue(lat, forKey: "lat")
      coordinate.setValue(lon, forKey: "lon")
      sInstance.entity.setValue(coordinate, forKey: "coordinate")
    }
  }
  
  private func setUpCoordinate(_ lat: Double?, _ lon: Double?, manager: NSMigrationManager) {
    let coordinate = NSEntityDescription.insertNewObject(forEntityName: "CoordinateEntity",
                                                         into: manager.destinationContext)
    coordinate.setValue(lat, forKey: "lat")
    coordinate.setValue(lon, forKey: "lon")
    
  }
}
