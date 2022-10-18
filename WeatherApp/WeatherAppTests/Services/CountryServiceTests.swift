import XCTest
@testable import WeatherApp

class CountryServiceTests: XCTestCase {
    let countryService = CountryService(service: NetworkService(parser: NetworkParser()))
    let countryMock = CountryElement(name: Name(common: "United States",
                                                official: "United States of America"),
                                     flags: CoatOfArms(png: URL(string: "https://flagcdn.com/w320/us.png"),
                                                       svg: URL(string: "https://flagcdn.com/us.svg")),
                                     capital: ["Washington, D.C."],
                                     latlng: [38.0, -97.0])
    
    func testCountryByName() async {
        guard let response = try? await countryService.getCountry(by: "USA") else {
            return
        }
//        XCTAssertTrue(response[0].name.common == countryMock.name.common)
//        XCTAssertTrue(response[0].name.official == countryMock.name.official)
//        XCTAssertTrue(response[0].flags.png == countryMock.flags.png)
//        XCTAssertTrue(response[0].flags.svg == countryMock.flags.svg)
//        XCTAssertTrue(response[0].capital == countryMock.capital)
//        XCTAssertTrue(response[0].latlng == countryMock.latlng)
    }
}
