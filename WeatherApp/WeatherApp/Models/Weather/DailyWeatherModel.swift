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
}
