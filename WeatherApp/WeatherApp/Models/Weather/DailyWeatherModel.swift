import Foundation

struct DailyWeatherModel: Decodable, Identifiable, Equatable, EntityComparable {
    
    typealias Entity = DailyWeatherEntity
    
    var id: UUID { UUID() }
    let daytime: Double
    let temp: Temperature
    var weather: [Weather]
    
    enum CodingKeys: String, CodingKey {
        case daytime = "dt"
        case temp
        case weather
    }
    
    init(_ model: DailyWeatherEntity?) {
        self.daytime = model?.daytime ?? 0
        self.temp = Temperature(model?.temp)
        self.weather = model?.weather?.compactMap { Weather($0 as? WeatherEntity) } ?? []
    }
    
    func saveAsEntity(_ dataController: CoreDataController) -> DailyWeatherEntity {
        let dailyEntity = DailyWeatherEntity(context: dataController.context)
        dailyEntity.id = id
        dailyEntity.daytime = daytime
        dailyEntity.temp = temp.saveAsEntity(dataController)
        dailyEntity.weather = NSSet(array: weather.compactMap { $0.saveAsEntity(dataController) })
        return dailyEntity
    }
}
