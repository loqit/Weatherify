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
    
    // MARK: - Properties

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
    
    // MARK: - Tests

    func testFetchCountriesSuccessfully() async {
        let parser = CountryNetworkParserMock()
        countriesVM = creator.factoryMethod(parser: parser)
        let exp = expectation(description: "TEST")
        self.countriesVM?.$countries
            .dropFirst()
            .sink { value in
                XCTAssertEqual(value[0].name.common, "United States")
                exp.fulfill()
            }
            .store(in: &self.cancellables)
        await countriesVM?.load()
        await waitForExpectations(timeout: 5)
    }
    
    func testEmptyResponse() async {
        let exp = expectation(description: "Empty Response")
        let parser = EmptyCountriesNetworkParserMock()
        countriesVM = creator.factoryMethod(parser: parser)
        countriesVM?.$error
            .dropFirst()
            .sink { value in
                XCTAssertNotNil(value)
                exp.fulfill()
            }
            .store(in: &cancellables)
        await countriesVM?.load()
        await waitForExpectations(timeout: 5)
    }
    
    func testWrongResponse() async {
        let exp = expectation(description: "Wrong Response")
        let parser = WrongCountryNetworkParserMock()
        countriesVM = creator.factoryMethod(parser: parser)
        countriesVM?.$error
            .dropFirst()
            .sink { value in
                XCTAssertNotNil(value)
                exp.fulfill()
            }
            .store(in: &cancellables)
        await countriesVM?.load()
        await waitForExpectations(timeout: 5)
    }
}
