import Foundation

protocol NetworkServiceProtocol {
    func getData<T: Codable>(from url: URL) async throws -> T
}

class NetworkService: NetworkServiceProtocol {
    func getData<T: Codable>(from url: URL) async throws -> T {
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(T.self, from: data)
        return response
    }
}
