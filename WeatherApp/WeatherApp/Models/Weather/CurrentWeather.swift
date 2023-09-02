import Foundation

struct CurrentWeather: Decodable, Identifiable, Equatable {
    
    var id: UUID { UUID() }
    let daytime: Double
    let temp: Double
    let pressure: Int
    let uvi: Double
    var weather: [Weather]
    
    enum CodingKeys: String, CodingKey {

        case daytime = "dt"
        case temp
        case weather
        case pressure
        case uvi
    }
    
    init(_ model: CurrentWeatherEntity?) {
        self.daytime = model?.daytime ?? 0
        self.temp = model?.temp ?? 0
        self.weather = model?.weather?.compactMap { Weather($0 as? WeatherEntity) } ?? []
        self.pressure = 0 // FIXME: should be fixed
        self.uvi = 0
    }
}
