import Foundation

struct CurrentWeather: Decodable, Identifiable, Equatable {
    
    var id: UUID { UUID() }
    let daytime: Double
    let temp: Double
    var weather: [Weather]
    
    enum CodingKeys: String, CodingKey {

        case daytime = "dt"
        case temp
        case weather
    }
}
