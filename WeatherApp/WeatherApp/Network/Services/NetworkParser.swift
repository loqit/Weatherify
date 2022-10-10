import Foundation
import SwiftUI

protocol NetworkParserProtocol {
    func decode<Value: Decodable>(_ data: Data) -> Result<Value, Error>
}

class NetworkParser: NetworkParserProtocol {
    func decode<Value: Decodable>(_ data: Data) -> Result<Value, Error> {
        do {
            let value = try JSONDecoder().decode(Value.self, from: data)
            return .success(value)
        } catch {
            print("Some error occur during decoding")
            return .failure(error)
        }
    }
}
