import XCTest
@testable import WeatherApp

class DateFormatServiceTests: XCTestCase {
    
    let timeMock = "10:16 AM"
    let shortDateMock = "1/2/70"
    let dateIntervalMock = 112560.0
    
    func testTimeFromDate() {
        let time = DateFormatService.timeFromDate(dateIntervalMock)
        XCTAssertEqual(time, timeMock)
    }
    
    func testShortDate() {
        let shortDate = DateFormatService.shortDate(dateIntervalMock)
        XCTAssertEqual(shortDate, shortDateMock)
    }
}
