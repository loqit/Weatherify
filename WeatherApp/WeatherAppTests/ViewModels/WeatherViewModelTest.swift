import XCTest
import Combine
@testable import WeatherApp

enum JSONNames: String {
    case weatherResponse = "WeatherResponse"
    case citiesResponse = "CitiesResponse"
    case countryResponse = "CountryResponse"
}

//class NetworkParserMock: NetworkParserProtocol {
//    func decode<Value: Decodable>(_ data: Data) -> Result<Value, Error> {
//        
//        return .success(<#T##Decodable#>)
//    }
//}

class WeatherNetworkServiceMock: NetworkServiceProtocol, Mockable {
    func getData<T: Decodable>(from url: URL) async throws -> T {
        return loadJSON(filename: JSONNames.weatherResponse.rawValue, type: T.self)
    }
}

class WeatherViewModelTest: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    private var weatherVM: WeatherViewModel?
    
    override func setUp() async throws {
        weatherVM = WeatherViewModel(service: WeatherService(service: WeatherNetworkServiceMock()))
    }

    override func tearDown() async throws {
        try await super.tearDown()
        cancellables = []
    }
    
    func testFetchWeatherSuccessfully() async {
        let exp = expectation(description: "Fetched Weather💩")
        await weatherVM?.load(for: CityElement(name: "", lat: 0, lon: 0, country: "", state: ""))
        weatherVM?.$weatherData
            .dropFirst()
            .sink(receiveValue: { value in
                XCTAssertEqual(value?.lat, 33.44)
                exp.fulfill()
            })
            .store(in: &cancellables)
        await waitForExpectations(timeout: 1)
    }
    
    
}
