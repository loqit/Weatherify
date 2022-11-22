import Foundation

class HashService {
  static func getHash(from lat: Double, and lon: Double) -> Int {
    return lat.hashValue ^ lon.hashValue
  }
}
