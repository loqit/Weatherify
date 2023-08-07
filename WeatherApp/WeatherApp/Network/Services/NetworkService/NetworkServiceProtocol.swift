import Foundation

protocol NetworkServiceProtocol {
    
    func fetchResponse<T: Decodable>(from url: URL) async throws -> Result<T, Error>
}
