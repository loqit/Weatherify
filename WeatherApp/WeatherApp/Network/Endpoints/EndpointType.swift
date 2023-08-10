import Foundation

protocol EndpointType {
    
    var baseUrl: String { get }
    var fullPath: String { get }
    var url: URL { get }
}

extension EndpointType {

    var url: URL {
        guard let url = URL(string: fullPath) else {
            print(fullPath)
            preconditionFailure("The url used in \(String(describing: self)) is not valid")
        }
        return url
    }
}
