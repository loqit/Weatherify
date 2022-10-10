import XCTest
@testable import WeatherApp

struct TestImage: Decodable {
    var image: URL
}

class NetworkServiceTests: XCTestCase {
//    let networkService = NetworkService()
//    
//    func testService() async {
//        let url = URL(string: "http://openweathermap.org/img/w/10d.png")!
//        guard let data: TestImage = try? await networkService.getData(from: url) else {
//            return
//        }
//        XCTAssertNotNil(data)
//        XCTAssertEqual(url, data.image)
//    }
}
