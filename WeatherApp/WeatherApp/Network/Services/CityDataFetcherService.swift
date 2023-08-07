import Foundation

class CityDataFetcherService {
    
    // MARK: Properties
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    // MARK: Public
    
    func fetchData(from url: URL, _ name: String) async -> Result<[City], Error> {
        //    do {
        //      print("Start Fetching")
        //      let data: Result<[City], Error> = try await networkService.fetchResponse(from: url)
        //      return data
        //    } catch {
        let result = await fetchLocally(by: name)
        return result
        //    }
    }
    
    // MARK: Private
    
    private func fetchLocally(by name: String, _ error: Error? = nil) async -> Result<[City], Error> {
        //    let errorCode = (error as NSError).code
        //    castError(errorCode: errorCode)
        //    guard errorCode != URLError.cancelled.rawValue else {
        //      return .failure(error)
        //    }
        
        do {
            let data = try uploadFromDataBase(by: name)
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
    
    private func uploadFromDataBase(by name: String) throws -> [City] {
        let cityCoreDataService = CityCoreDataService(dataController: CoreDataController())
        do {
            let city = try cityCoreDataService.fetch(by: name)
            return city
        } catch {
            throw error
        }
    }
}
