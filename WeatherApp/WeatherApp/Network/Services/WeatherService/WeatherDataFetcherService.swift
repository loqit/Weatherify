import Foundation

class WeatherDataFetcherService {
    
    // MARK: Properties
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    // MARK: Public
    
    func fetchData(from url: URL, _ cityID: Int) async -> Result<WeatherModel, Error> {
        do {
            let data: Result<WeatherModel, Error> = try await networkService.fetchResponse(from: url)
            return data
        } catch {
            let result = await fetchLocally(by: cityID, error)
            return result
        }
    }
    
    // MARK: Private
    
    private func fetchLocally(by cityID: Int, _ error: Error) async -> Result<WeatherModel, Error> {
        let errorCode = (error as NSError).code
        castError(errorCode: errorCode)
        guard errorCode != URLError.cancelled.rawValue else {
            return .failure(error)
        }
        do {
            let data = try await uploadFromDataBase(by: cityID)
            return .success(data)
        } catch {
            return .failure(error)
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
    
    @MainActor
    private func uploadFromDataBase(by id: Int) throws -> WeatherModel {
        let coreDataService = CoreDataController<WeatherEntity>()
        coreDataService.fetch(predicate: NSPredicate(format: "id = %@", id))
    }
}
