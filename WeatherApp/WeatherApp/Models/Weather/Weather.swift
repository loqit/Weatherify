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
}
