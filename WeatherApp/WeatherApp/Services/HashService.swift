import Foundation

class HashService {

    static func getHash(from lat: Double, and lon: Double) -> Int {
        Int(lat * lon - lat + lon)
    }
}
