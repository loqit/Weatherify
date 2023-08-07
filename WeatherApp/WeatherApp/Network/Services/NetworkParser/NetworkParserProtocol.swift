import Foundation

protocol NetworkParserProtocol {
    
    func decode<Value: Decodable>(_ data: Data) -> Result<Value, Error>
}
