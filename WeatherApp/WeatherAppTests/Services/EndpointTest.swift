import XCTest
@testable import WeatherApp

class EndpointTest: XCTestCase {
    // swiftlint:disable line_length
    
    var oneCallEndpointMock = "https://api.openweathermap.org/data/3.0/onecall?lat=40.730610&lon=-73.935242&exclude=alerts&appid=4b64504f9c0e072ede8aa685c2df3a15&units=metric"
    var geoUrlMock = "https://api.openweathermap.org/geo/1.0/direct?q=New York&limit=5&appid=4b64504f9c0e072ede8aa685c2df3a15"
    var iconUrlMock = "https://api.openweathermap.org/img/w/10d.png"
    
    func testOneCallEndpointGeneration() {
        let endpoint: OpenWeatherEndpoint = .oneCallUrl("40.730610", "-73.935242")
        XCTAssertEqual(endpoint.fullPath, oneCallEndpointMock)
    }
    
    func testGeoUrl() {
        let endpoint: OpenWeatherEndpoint = .geoUrl("New York")
        XCTAssertEqual(endpoint.fullPath, geoUrlMock)
    }
    
    func testIconUrl() {
        let endpoint: OpenWeatherEndpoint = .iconUrl("10d")
        XCTAssertEqual(endpoint.fullPath, iconUrlMock)
    }
    
}
