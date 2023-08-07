import Foundation

class HashService {
    // FIXME: Backend has no ids for unique fields
    static func getHash(from lat: Double, and lon: Double) -> Int {
        //    var hasher = Hasher()
        //    hasher.combine(lat)
        //    hasher.combine(lon)
        //    return hasher.finalize()
        return Int(lat * lon - lat + lon)
    }
}
