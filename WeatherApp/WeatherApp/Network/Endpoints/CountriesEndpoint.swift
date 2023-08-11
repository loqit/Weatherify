import Foundation

enum CountriesEndpoint: EndpointType {

    var baseUrl: String { return "https://restcountries.com/v3.1" }

    case name(String)
    case all

    var fullPath: String {
        var endpoint: String
        switch self {
        case let .name(name):
            endpoint = "/name/\(name)"
        default:
            endpoint = "/\(String(describing: self))"
        }
        endpoint = endpoint
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "%20")
        return baseUrl + endpoint
    }
}
