import XCTest
import Combine
@testable import WeatherApp

class CountryNetworkParserMock: NetworkParserProtocol, Mockable {
    func decode<Value: Decodable>(_ data: Data) -> Result<Value, Error> {
        let mockData = loadJSON(filename: JSONNames.countryResponse.rawValue, type: Value.self)
        return .success(mockData)
    }
}

class CountriesViewModelTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    private var countiesVM: CountriesViewModel?
    
    override func setUp() async throws {
        try await super.setUp()
        let creator = CountriesViewModelCreator()
        let parser = CountryNetworkParserMock()
        countiesVM = creator.factoryMethod(parser: parser)
    }
    
    override func tearDown() async throws {
        try await super.tearDown()
        countiesVM = nil
        cancellables = []
    }
    
    func testFetchCountriesSuccessfully() async {
        let exp = expectation(description: "Fetched Countries")
        await countiesVM?.load()
        countiesVM?
            .$countries
            .dropFirst()
            .sink { value in
                XCTAssertEqual(value[0].name.common, "United States")
                exp.fulfill()
            }
            .store(in: &cancellables)
        await waitForExpectations(timeout: 2)
    }
}
