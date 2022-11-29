import Foundation

class HashService {
  static func getHash(from lat: Double, and lon: Double) -> Int {
//    var hasher = Hasher()
//    hasher.combine(lat)
//    hasher.combine(lon)
//    return hasher.finalize()
    return Int(lat * lon - lat + lon)
  }
}

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
