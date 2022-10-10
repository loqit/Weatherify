import Foundation

protocol NetworkServiceProtocol {
    func getData<T: Decodable>(from url: URL) async throws -> T
    func fetchResponse<T: Decodable>(from url: URL) async throws -> Result<T, Error>
}

// MARK: - Use marks

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

    // TODO: Return Result insted of T
    func fetchResponse<T: Decodable>(from url: URL) async throws -> Result<T, Error> {
        let data = try await getData(from: url)
        let result: Result<T, Error> = parser.decode(data)
        return result
//        switch result {
//        case .success(let data):
//            print("💩", data)
//            return data
//        case .failure(let error):
//            throw error
//        }
    }
}
