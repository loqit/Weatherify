import Foundation

struct ResponseList: Codable, Identifiable {
    let id: Double
    let main: MainData
    let weather: [WeatherData]
    let clouds: CloudsData
    let wind: WindData
    let visibility: Int
    let pop: Double
    let rain: RainData?
    let sys: SysData
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case id = "dt"
        case main, weather, clouds, wind, visibility, pop, rain, sys
        case dtTxt = "dt_txt"
    }
}
