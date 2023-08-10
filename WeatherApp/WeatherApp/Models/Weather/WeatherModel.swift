import Foundation
import CoreLocation

struct WeatherModel: Decodable, Equatable {

    let lat, lon: Double
    let timezone: String
    let current: CurrentWeather
    var hourly: [CurrentWeather]
    var daily: [DailyWeatherModel]
    
    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case current, hourly, daily
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    init(_ model: WeatherDataEntity?) {
        self.lat = model?.coordinate?.lat ?? 0
        self.lon = model?.coordinate?.lon ?? 0
        self.timezone = model?.timezone ?? ""
        self.current = CurrentWeather(model?.current)
        self.hourly = model?.hourly?.compactMap { CurrentWeather($0 as? CurrentWeatherEntity) } ?? []
        self.daily = model?.daily?.compactMap { DailyWeatherModel($0 as? DailyWeatherEntity) } ?? []
    }
    
    func saveAsEntity(_ dataController: CoreDataController) -> WeatherDataEntity {
        let weatherDataEntity = WeatherDataEntity(context: dataController.context)
        let coordinate = CoordinateEntity(context: dataController.context)
        weatherDataEntity.id = UUID()
        
        coordinate.lat = lat.round(to: 3)
        coordinate.lon = lon.round(to: 3)
        weatherDataEntity.coordinate = coordinate
        
        weatherDataEntity.timezone = timezone
        weatherDataEntity.current = current.saveAsEntity(dataController)
        weatherDataEntity.hourly = NSSet(array: hourly.compactMap { $0.saveAsEntity(dataController) })
        weatherDataEntity.daily = NSSet(array: daily.compactMap { $0.saveAsEntity(dataController) })
        weatherDataEntity.cityID = Int64(HashService.getHash(from: lat.round(to: 3),
                                                             and: lon.round(to: 3)))
        print(lat.round(to: 3), lon.round(to: 3))
        print("weather entity 🌎", weatherDataEntity.cityID)
        
        return weatherDataEntity
    }
}
