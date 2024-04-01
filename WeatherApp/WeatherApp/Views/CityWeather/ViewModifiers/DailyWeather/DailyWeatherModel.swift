import Foundation

final class DailyWeatherModel: ObservableObject {
    @Published var date: Double
    @Published var temp: Temperature
    @Published var iconName: String
    @Published var minWeekly: Double
    @Published var maxWeekly: Double

    init(date: Double, temp: Temperature, iconName: String, minWeekly: Double, maxWeekly: Double) {
        self.date = date
        self.temp = temp
        self.iconName = iconName
        self.minWeekly = minWeekly
        self.maxWeekly = maxWeekly
    }

    convenience init(dailyWeather: DailyWeatherModel, minWeekly: Double, maxWeekly: Double) {
        self.date = dailyWeather.date
        self.temp = dailyWeather.temp
        self.iconName = dailyWeather.iconName
        self.minWeekly = minWeekly
        self.maxWeekly = maxWeekly
    }
}
