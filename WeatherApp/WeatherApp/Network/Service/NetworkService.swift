import Foundation

protocol NetworkServiceProtocol {
    func getData<T: Decodable>(from url: URL) async throws -> T
}

class NetworkService: NetworkServiceProtocol {
    
    let parser: NetworkParserProtocol
    
    init(parser: NetworkParserProtocol) {
        self.parser = parser
    }
    
    func getData<T: Decodable>(from url: URL) async throws -> T {
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(T.self, from: data)
        return response
    }
    
    private func getData(from url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
    
    func fetchResponse<T: Decodable>(from url: URL) async throws -> T {
        let data = try await getData(from: url)
        let result: Result<T, Error> = parser.decode(data)
        switch result {
        case .success(let data):
            return data
        case .failure(let error):
            throw error
        }
    }
}
