import Foundation

struct Temperature: Decodable {
  let day, min, max, night: Double
  let eve, morn: Double
}
