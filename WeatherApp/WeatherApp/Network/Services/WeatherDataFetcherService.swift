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
      print("Start Fetching")
      let data: Result<WeatherModel, Error> = try await networkService.fetchResponse(from: url)
      return data
    } catch {
      let errorCode = (error as NSError).code
      castError(errorCode: errorCode)
      guard errorCode != URLError.cancelled.rawValue else {
        return .failure(error)
      }
      
      do {
        let data = try uploadFromDataBase(by: cityID)
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
  
  private func uploadFromDataBase(by id: Int) throws -> WeatherModel {
    let coreDataService = WeatherCoreDataService(dataController: DataController())
    do {
      let weather = try coreDataService.fetch(by: id)
      return weather
    } catch {
      throw error
    }
  }
}
