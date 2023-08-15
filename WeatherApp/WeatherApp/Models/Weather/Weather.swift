import Foundation

struct Weather: Decodable, Equatable {

    let id: Int
    let main: String
    let weatherDescription: String
    let icon: String
    
    enum CodingKeys: String, CodingKey {

        case id, main
        case weatherDescription = "description"
        case icon
    }

    init(_ model: WeatherEntity?) {
        self.id = Int(model?.id ?? 0)
        self.main = model?.main ?? ""
        self.weatherDescription = model?.weatherDescription ?? ""
        self.icon = model?.icon ?? ""
    }
}
