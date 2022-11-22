import Foundation

class DataFetcherService {
  
  // MARK: Properties
  
  private let networkService: NetworkServiceProtocol
  
  init(networkService: NetworkServiceProtocol) {
    self.networkService = networkService
  }
  
  // MARK: Public
  
  func fetchData<T: Decodable>(from url: URL, _ name: String) async -> Result<T, Error> {
    do {
      print("Start Fetching")
      let data: Result<T, Error> = try await networkService.fetchResponse(from: url)
      return data
    } catch {
      let errorCode = (error as NSError).code
      castError(errorCode: errorCode)
      guard errorCode != URLError.cancelled.rawValue else {
        return .failure(error)
      }
      
      do {
        let data = try uploadFromDataBase(by: name) as T // Как сделать дженерик (разные параметры для запроса)
        return .success(data)
      } catch {
        return .failure(error)
      }
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
  
  private func uploadFromDataBase<T: Decodable>(by name: String) throws -> T {
    let cityCoreDataService = CityCoreDataService(dataController: DataController())
    do {
      let city = try cityCoreDataService.fetch(by: name) as? T
      return city!
    } catch {
      throw error
    }
  }
}
