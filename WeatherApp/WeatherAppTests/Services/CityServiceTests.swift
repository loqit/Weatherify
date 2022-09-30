import XCTest
@testable import WeatherApp

class CityServiceTests: XCTestCase {
    let cityService = CityService(service: NetworkService())
    let cityMock = CityElement(name: "Boston", lat: 42.3554334, lon: -71.060511, country: "US", state: "Massachusetts")
    
    func testService() async {
        guard let response = try? await cityService.getCitiesData(of: "Boston") else {
            return
        }
        XCTAssertNotNil(response)
        XCTAssertEqual(response[0].country, cityMock.country)
        XCTAssertEqual(response[0].name, cityMock.name)
        XCTAssertEqual(response[0].lat, cityMock.lat)
        XCTAssertEqual(response[0].lon, cityMock.lon)
        XCTAssertEqual(response[0].state, cityMock.state)
    }
}
