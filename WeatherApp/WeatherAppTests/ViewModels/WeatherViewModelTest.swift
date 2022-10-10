import XCTest
import Combine
@testable import WeatherApp

 class EmptyNetworkParserMock: NetworkParserProtocol, Mockable {
     func decode<Value: Decodable>(_ data: Data) -> Result<Value, Error> {
        let mockData = loadJSON(filename: JSONNames.empty.rawValue, type: Value.self)
        return .success(mockData)
    }
 }

class WeatherNetworkParserMock: NetworkParserProtocol, Mockable {
    func decode<Value: Decodable>(_ data: Data) -> Result<Value, Error> {
        let mockData = loadJSON(filename: JSONNames.weatherResponse.rawValue, type: Value.self)
        return .success(mockData)
    }
}

class WeatherViewModelTest: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    private var weatherVM: WeatherViewModel?
    
    override func setUp() async throws {
        try await super.setUp()
        let parser = WeatherNetworkParserMock()
        let creator = WeatherViewModelCreator()
        weatherVM = creator.factoryMethod(parser: parser)
    }

    override func tearDown() async throws {
        try await super.tearDown()
        cancellables = []
    }
    
    func testFetchWeatherSuccessfully() async {
        let exp = expectation(description: "Fetched Weather💩")
        weatherVM?.city = City(name: "", lat: 0, lon: 0, country: "", state: "")
        await weatherVM?.load()
        weatherVM?.$weatherData
            .dropFirst()
            .sink(receiveValue: { value in
                XCTAssertEqual(value?.lat, 33.44)
                exp.fulfill()
            })
            .store(in: &cancellables)
        await waitForExpectations(timeout: 1.5) // Перестало выполнятся за 1 ???
    }
    
    func testFetchWeatherEmpty() async {
        //
    }
}
