import Foundation
@testable import WeatherApp

enum MockEntities {
    
    static let cities: [City] = [
        City(name: "First City", lat: 1, lon: 1, country: "First Country", state: nil),
        City(name: "Second City", lat: 2, lon: 2, country: "Second Country", state: "Neverland"),
    ]
}
