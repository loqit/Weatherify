import Foundation

class CityDataFetcherService {
    
    // MARK: Properties
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    // MARK: Public
    
    func fetchData(from url: URL, _ name: String) async throws -> Result<[City], NetworkError> {
        try await networkService.fetchResponse(from: url)
    }
    
    // MARK: Private
    
    private func fetchLocally(by name: String, _ error: Error? = nil) async -> Result<[City], NetworkError> {
        do {
            let data = try await uploadFromDataBase(by: name)
            return .success(data)
        } catch {
            return .failure(NetworkError.inavlidData)
        }
    }
    
    private func castError(errorCode: Int) {
        switch errorCode {
        case URLError.timedOut.rawValue:
            print("timedOut ♦️")
        case URLError.cancelled.rawValue:
            print("cancelled ♦️")
        case URLError.cannotConnectToHost.rawValue:
            print("cannotConnectToHost ♦️")
        case URLError.notConnectedToInternet.rawValue:
            print("Not connected to internet ♦️")
        default:
            print("Some error occured")
        }
    }
    
    private func uploadFromDataBase(by name: String) async throws -> [City] {
        let coreDataService = CoreDataController<CityEntity>()
        async let result = await coreDataService.fetch(predicate: NSPredicate(format: "name = %@", name))
        switch await result {
        case let .success(entities):
            return entities.map { City($0) }
        case let .failure(error):
            throw error
        }
    }
}
