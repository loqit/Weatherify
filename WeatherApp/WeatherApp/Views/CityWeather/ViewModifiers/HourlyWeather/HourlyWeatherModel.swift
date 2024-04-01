import Foundation
import Combine

final class HourlyWeatherModel: ObservableObject {
    @Published var temp: String
    @Published var iconName: String
    @Published var time: String

    init(temp: String, iconName: String, time: String) {
        self.temp = temp
        self.iconName = iconName
        self.time = time
    }

    init(hourly: CurrentWeather) {
        self.temp = String(Int(hourly.temp))
        self.iconName = hourly.weather[0].icon
        self.time = DateFormatService.timeFromDate(hourly.daytime)
    }
}
