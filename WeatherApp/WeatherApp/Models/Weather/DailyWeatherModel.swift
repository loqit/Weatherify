import Foundation

struct DailyWeatherModel: Decodable, Identifiable, Equatable {

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
}
