import Foundation

protocol NetworkServiceProtocol {
    func fetchResponse<T: Decodable>(from url: URL) async throws -> Result<T, Error>
}

class NetworkService: NetworkServiceProtocol {
    
    private let parser: NetworkParserProtocol
    
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
            let data = try await getData(from: url)
            let result: Result<T, Error> = parser.decode(data)
            return result
        } catch {
            throw error
        }
    }
}
