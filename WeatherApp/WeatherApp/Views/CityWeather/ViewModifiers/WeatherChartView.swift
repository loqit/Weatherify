import SwiftUI
import Charts

struct WeatherChartView: View {
    
    // MARK: - Properties

    let data: [DailyWeatherModel]
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            List {
                Chart(data) { weather in
                    LineMark(x: .value("Day", DateFormatService.dayOfWeek(weather.daytime)),
                             y: .value("Temp", weather.temp.max))
                    PointMark(x: .value("Day", DateFormatService.dayOfWeek(weather.daytime)),
                              y: .value("Temp", weather.temp.max))
                    
                    LineMark(x: .value("Day", DateFormatService.dayOfWeek(weather.daytime)),
                             y: .value("Temp", weather.temp.min))
                    PointMark(x: .value("Day", DateFormatService.dayOfWeek(weather.daytime)),
                              y: .value("Temp", weather.temp.min))
                }
            }
        }
        .onAppear {
            print(data)
        }
    }
    
    // MARK: - Private
}
