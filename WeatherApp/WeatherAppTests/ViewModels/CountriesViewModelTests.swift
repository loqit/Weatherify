import XCTest
import Combine
@testable import WeatherApp

class EmptyCountriesNetworkParserMock: NetworkParserProtocol, Mockable {
    func decode<Value: Decodable>(_ data: Data) -> Result<Value, Error> {
        do {
            let mockData = try loadJSON(filename: JSONNames.emptyCountry.rawValue, type: Value.self)
            return .success(mockData)
        } catch {
            return .failure(error)
        }
    }
}

class CountryNetworkParserMock: NetworkParserProtocol, Mockable {
    func decode<Value: Decodable>(_ data: Data) -> Result<Value, Error> {
        do {
            let mockData = try loadJSON(filename: JSONNames.countryResponse.rawValue, type: Value.self)
            return .success(mockData)
        } catch {
            return .failure(error)
        }
    }
}

class WrongCountryNetworkParserMock: NetworkParserProtocol, Mockable {
    func decode<Value: Decodable>(_ data: Data) -> Result<Value, Error> {
        do {
            let mockData = try loadJSON(filename: JSONNames.wrongCountry.rawValue, type: Value.self)
            return .success(mockData)
        } catch {
            return .failure(error)
        }
    }
}

class CountriesViewModelTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    private var countriesVM: CountriesViewModel?
    private let creator = CountriesViewModelCreator()
    
    override func setUp() async throws {
        try await super.setUp()
        cancellables = []
    }
    
    override func tearDown() async throws {
        try await super.tearDown()
        countriesVM = nil
        cancellables = []
    }
    
    func testFetchCountriesSuccessfully() async {
        let exp = expectation(description: "Fetched Countries")
        let parser = CountryNetworkParserMock()
        countriesVM = creator.factoryMethod(parser: parser)

        await countriesVM?.load()
        countriesVM?.$countries
            .dropFirst()
            .sink { value in
                XCTAssertEqual(value[0].name.common, "United States")
                exp.fulfill()
            }
            .store(in: &cancellables)
        await waitForExpectations(timeout: 10)
    }
    
    func testEmptyResponse() async { 
        let exp = expectation(description: "Fetched Countries")
        let parser = EmptyCountriesNetworkParserMock()
        countriesVM = creator.factoryMethod(parser: parser)

        await countriesVM?.load()
        countriesVM?.$error
            .dropFirst()
            .sink { value in
                XCTAssertNotNil(value)
                exp.fulfill()
            }
            .store(in: &cancellables)
        await waitForExpectations(timeout: 10)
    }
    
    func testWrongResponse() async {
        let exp = expectation(description: "Fetched Countries")
        let parser = WrongCountryNetworkParserMock()
        countriesVM = creator.factoryMethod(parser: parser)

        await countriesVM?.load()
        countriesVM?.$error
            .dropFirst()
            .sink { value in
                XCTAssertNotNil(value)
                exp.fulfill()
            }
            .store(in: &cancellables)
        await waitForExpectations(timeout: 10)
    }
}
