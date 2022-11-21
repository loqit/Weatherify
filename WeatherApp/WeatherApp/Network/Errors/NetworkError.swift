import Foundation

enum NetworkError: String, Error {
  case inavlidData
  case invalidUrl
  case connectionError
}

extension NetworkError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .inavlidData:
      return "Invalid data from server. Please, try again."
    case .invalidUrl:
      return "Invalid url. Please, try again."
    case .connectionError:
      return "No Internet connection"
    }
  }
}
