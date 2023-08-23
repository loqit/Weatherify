import Foundation

class NetworkParser: NetworkParserProtocol {
    
    func decode<Value: Decodable>(_ data: Data) -> Result<Value, NetworkError> {
        do {
            let value = try JSONDecoder().decode(Value.self, from: data)
            return .success(value)
        } catch {
            print("Some error occur during decoding")
            return .failure(NetworkError.inavlidData)
        }
    }
}
