import Foundation
import CoreLocation

struct WeatherModel: Decodable, Equatable {

    let lat, lon: Double
    let timezone: String
    let current: CurrentWeather
    var hourly: [CurrentWeather]
    var daily: [DailyWeatherModel]

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }

    enum CodingKeys: String, CodingKey {

        case lat, lon, timezone
        case current, hourly, daily
    }
    
    init(_ model: WeatherDataEntity?) {
        self.lat = model?.coordinate?.lat ?? 0
        self.lon = model?.coordinate?.lon ?? 0
        self.timezone = model?.timezone ?? ""
        self.current = CurrentWeather(model?.current)
        self.hourly = model?.hourly?.compactMap { CurrentWeather($0 as? CurrentWeatherEntity) } ?? []
        self.daily = model?.daily?.compactMap { DailyWeatherModel($0 as? DailyWeatherEntity) } ?? []
    }
}
