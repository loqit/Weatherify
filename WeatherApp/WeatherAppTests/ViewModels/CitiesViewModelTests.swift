import XCTest
import Combine
@testable import WeatherApp

class CitiesNetworkParserMock: NetworkParserProtocol, Mockable {
    func decode<Value: Decodable>(_ data: Data) -> Result<Value, Error> {
        do {
            let mockData = try loadJSON(filename: JSONNames.citiesResponse.rawValue, type: Value.self)
            return .success(mockData)
        } catch {
            return .failure(error)
        }
    }
}

class EmptyCitiesNetworkParserMock: NetworkParserProtocol, Mockable {
    func decode<Value: Decodable>(_ data: Data) -> Result<Value, Error> {
        do {
            let mockData = try loadJSON(filename: JSONNames.emptyCountry.rawValue, type: Value.self)
            return .success(mockData)
        } catch {
            return .failure(error)
        }
    }
}

class CitiesViewModelTests: XCTestCase {
    var citiesVM: CitiesViewModel?
    private var cancellables = Set<AnyCancellable>()
    private let creator = CitiesViewModelCreator()

    override func setUp() async throws {
        try await super.setUp()
        cancellables = []
    }

    override func tearDown() async throws {
        try await super.tearDown()
        citiesVM = nil
        cancellables = []
    }

    func testFetchCitiesSuccessfully() async {
        let exp = expectation(description: "Fetched Cities")
        let parser = CitiesNetworkParserMock()
        citiesVM = creator.factoryMethod(parser: parser)
        citiesVM?.searchTerm = "Boston"
        citiesVM?.$cities
            .dropFirst()
            .sink { value in
                XCTAssertEqual(value[0].country, "US")
                exp.fulfill()
            }
            .store(in: &cancellables)
        await citiesVM?.load()
        await waitForExpectations(timeout: 2)
    }
    
    func testEmptyResponse() async {
        let exp = expectation(description: "Fetched Cities")
        let parser = EmptyCountriesNetworkParserMock()
        citiesVM = creator.factoryMethod(parser: parser)
        citiesVM?.searchTerm = "Boston"
        citiesVM?.$error
            .dropFirst()
            .sink { value in
                XCTAssertNotNil(value)
                exp.fulfill()
            }
            .store(in: &cancellables)
        await citiesVM?.load()
        await waitForExpectations(timeout: 2)
    }
}
