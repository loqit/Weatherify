import Foundation

struct WeatherData {
    let id: Int
    let main: MainDescription
    let weatherDescription: WeatherDescription
    let icon: Icon

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}
