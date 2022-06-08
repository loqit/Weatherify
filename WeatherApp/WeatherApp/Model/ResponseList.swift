import Foundation

struct ResponseList: Codable {
    let dt: Int
    let main: MainData
    let weather: [String]
    let clouds: String
    let wind: String
    let visibility: Int
    let pop: Double
    let rain: String?
    let sys: String
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, rain, sys
        case dtTxt = "dt_txt"
    }
}
