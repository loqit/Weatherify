import Foundation

enum OpenWeatherEndpoint: EndpointType {
    var baseUrl: String { return "https://api.openweathermap.org" }
    var apiKey: String { return "4b64504f9c0e072ede8aa685c2df3a15" }
    
    case oneCallUrl(Double, Double)
    case geoUrl(String)
    case iconUrl(String)
    
    var fullPath: String {
        var endpoint: String
        switch self {
        case .oneCallUrl(let lat, let lon):
            endpoint = "/data/3.0/onecall?lat=\(lat)&lon=\(lon)&exclude=alerts&appid=\(apiKey)&units=metric"
        case .geoUrl(let name):
            endpoint = "/geo/1.0/direct?q=\(name)&limit=5&appid=\(apiKey)"
        case .iconUrl(let name):
            endpoint = "/img/w/\(name).png"
        }
        return baseUrl + endpoint
    }
}
