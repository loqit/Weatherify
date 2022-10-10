import XCTest
import Combine
@testable import WeatherApp

class CitiesNetworkParser: NetworkParserProtocol, Mockable {
    func decode<Value: Decodable>(_ data: Data) -> Result<Value, Error> {
        let mockData = loadJSON(filename: JSONNames.citiesResponse.rawValue, type: Value.self)
        return .success(mockData)
    }
}

class CitiesViewModelTests: XCTestCase {
    var citiesVM: CitiesViewModel?
    private var cancellables = Set<AnyCancellable>()

    override func setUp() async throws {
        try await super.setUp()
        let creator = CitiesViewModelCreator()
        let parser = CitiesNetworkParser()
        citiesVM = creator.factoryMethod(parser: parser)
        cancellables = []
    }

    override func tearDown() async throws {
        try await super.tearDown()
        print("💩Tear down💩")
        citiesVM = nil
        cancellables = []
    }

    func testFetchCitiesSuccessfully() async {
        let exp = expectation(description: "Fetched Cities")
        citiesVM?.searchTerm = "Boston"
        citiesVM?
            .$cities
            .dropFirst()
            .sink { value in
                if !value.isEmpty {
                    XCTAssertEqual(value[0].country, "US")
                }
                exp.fulfill()
            }
            .store(in: &cancellables)

        await citiesVM?.load()
        await waitForExpectations(timeout: 2)
    }
}
