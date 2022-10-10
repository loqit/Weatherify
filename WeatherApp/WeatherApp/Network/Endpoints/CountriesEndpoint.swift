import Foundation

enum CountriesEndpoint: EndpointType {
    var baseUrl: String { return "https://restcountries.com/v3.1" }

    case name(String)
    case all

    var fullPath: String {
        var endpoint: String
        switch self {
        case .name(let name):
            endpoint = "/name/\(name)"
        default:
            endpoint = "/\(String(describing: self))"
        }
        return baseUrl + endpoint
    }
}
