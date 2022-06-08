import Foundation

struct ResponseBody: Codable {
    let cod: String
    let message, cnt: Int
    let list: [ResponseList]
    let city: City
}
