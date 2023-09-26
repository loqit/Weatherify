import XCTest
import ComposableArchitecture
@testable import WeatherApp

@MainActor
final class CitySearchReducerTests: XCTestCase {
    
    func testFailedResponse() async {
        let store = TestStore(initialState: SearchCityReducer.State()) {
            SearchCityReducer()
        }
        
        await store.send(.searchResponse(.failure(.inavlidData))) {
            $0.searchError = .inavlidData
            $0.cities = []
        }
    }
    
    func testSuccessResponse() async {
        let store = TestStore(initialState: SearchCityReducer.State()) {
            SearchCityReducer()
        }
         
        await store.send(.searchResponse(.success(MockEntities.cities))) {
            $0.cities = MockEntities.cities
            $0.searchError = nil
        }
    }
}
