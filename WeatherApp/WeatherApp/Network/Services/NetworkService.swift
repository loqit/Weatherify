import Foundation

protocol NetworkServiceProtocol {
  func fetchResponse<T: Decodable>(from url: URL) async throws -> Result<T, Error>
}

class NetworkService: NetworkServiceProtocol {
  
  private let parser: NetworkParserProtocol
  private weak var task: URLSessionDataTask?
  private var loadTask: Task<Data, Error>?
  
  init(parser: NetworkParserProtocol) {
    self.parser = parser
  }

  private func getData(from url: URL) async throws -> Data {
      do {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
      } catch {
        throw error
      }
  }
  
  func fetchResponse<T: Decodable>(from url: URL) async throws -> Result<T, Error> {
    do {
      loadTask?.cancel()
      loadTask = Task { () -> Data in
         return try await getData(from: url)
      }
      
      let data = try await loadTask?.value ?? Data()
      let result: Result<T, Error> = parser.decode(data)
      return result
    } catch {
      throw error
    }
  }
  
  func cancelRequest() {
    loadTask?.cancel()
  }
}
