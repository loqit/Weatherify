import Foundation

class DataFetcherService {
  
  // MARK: Properties
  
  private let networkService: NetworkServiceProtocol
  
  init(networkService: NetworkServiceProtocol) {
    self.networkService = networkService
  }
  
  // MARK: Public
  
  func fetchData<T: Decodable>(from url: URL, _ name: String) async -> Result<T, Error>? {
    do {
      print("Start Fetching")
      let data: Result<T, Error> = try await networkService.fetchResponse(from: url)
      return data
    } catch {
      let errorCode = (error as NSError).code
      castError(errorCode: errorCode)
      let data: T? = uploadFromDataBase(by: name)
      guard let result = data else {
        return nil
      }
      return .success(result)
    }
  }
  
  // MARK: Private
  
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
  
  private func uploadFromDataBase<T: Decodable>(by name: String) -> T? {
    let cityCoreDataService = CityCoreDataService(dataController: DataController())
    let city = cityCoreDataService.fetch(by: name) as? T
    return city
  }
}
