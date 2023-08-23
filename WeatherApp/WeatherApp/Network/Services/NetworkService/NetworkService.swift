import Foundation

class NetworkService: NetworkServiceProtocol {
    
    // MARK: Properties
    
    private let parser: NetworkParserProtocol
    private weak var task: URLSessionDataTask?
    private var loadTask: Task<Data, Error>?
    
    init(parser: NetworkParserProtocol) {
        self.parser = parser
    }
    
    // MARK: Public
    
    func fetchResponse<T: Decodable>(from url: URL) async -> Result<T, NetworkError> {
        do {
            cancelRequest()
            loadTask = Task {
                try await getData(from: url)
            }
            
            guard let data = try await loadTask?.value else {
                return .failure(NetworkError.inavlidData)
             //   throw NetworkError.inavlidData
            }
            let result: Result<T, NetworkError> = parser.decode(data)
            return result
        } catch {
           // throw error
            return .failure(NetworkError.inavlidData)
        }
    }
    
    func cancelRequest() {
        loadTask?.cancel()
    }
    
    // MARK: Private
    
    private func getData(from url: URL) async throws -> Data {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                throw NetworkError.connectionError
            }
            return data
        } catch {
            throw error
        }
    }
}
