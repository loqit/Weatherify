import XCTest
import Combine
@testable import WeatherApp

class EmptyWeatherNetworkParserMock: NetworkParserProtocol, Mockable {
  func decode<Value: Decodable>(_ data: Data) -> Result<Value, Error> {
    do {
      let mockData = try loadJSON(filename: JSONNames.empty.rawValue, type: Value.self)
      return .success(mockData)
    } catch {
      return .failure(error)
    }
  }
}

class WeatherNetworkParserMock: NetworkParserProtocol, Mockable {
  func decode<Value: Decodable>(_ data: Data) -> Result<Value, Error> {
    do {
      let mockData = try loadJSON(filename: JSONNames.weatherResponse.rawValue, type: Value.self)
      return .success(mockData)
    } catch {
      return .failure(error)
    }
  }
}

class WeatherViewModelTests: XCTestCase {
  private var cancellables = Set<AnyCancellable>()
  private var weatherVM: WeatherViewModel?
  private let creator = WeatherViewModelCreator()
  
  override func setUp() async throws {
    try await super.setUp()
    let parser = WeatherNetworkParserMock()
    
    weatherVM = creator.factoryMethod(parser: parser)
  }
  
  override func tearDown() async throws {
    try await super.tearDown()
    cancellables = []
  }
  
  func testFetchWeatherSuccessfully() async {
    let exp = expectation(description: "Fetched Weather💩")
    let parser = WeatherNetworkParserMock()
    weatherVM = creator.factoryMethod(parser: parser)
    weatherVM?.city = City(name: "", lat: 0, lon: 0, country: "", state: "")
    weatherVM?.$weatherData
      .dropFirst()
      .sink { value in
        XCTAssertEqual(value?.lat, 33.44)
        exp.fulfill()
      }
      .store(in: &cancellables)
    await weatherVM?.load()
    await waitForExpectations(timeout: 5)
  }
  
  func testFetchWeatherEmpty() async {
    let exp = expectation(description: "Fetched Weather💩")
    let parser = EmptyWeatherNetworkParserMock()
    weatherVM = creator.factoryMethod(parser: parser)
    weatherVM?.city = City(name: "", lat: 0, lon: 0, country: "", state: "")
    
    weatherVM?.$error
      .dropFirst()
      .sink { value in
        XCTAssertNotNil(value)
        exp.fulfill()
      }
      .store(in: &cancellables)
    await weatherVM?.load()
    await waitForExpectations(timeout: 5)
  }
}
