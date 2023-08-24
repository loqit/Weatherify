import SwiftUI
import Charts

struct WeatherChartView: View {
    
    // MARK: - Properties

    let data: [CurrentWeather]
    let minTemp: Int
    let maxTemp: Int
    
    init(data: [CurrentWeather]) {
        self.data = data
        minTemp = Int(data.map { $0.temp }.min() ?? 0)
        maxTemp = Int(data.map { $0.temp }.max() ?? 0)
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            List {
                Chart(data) {
                    LineMark(x: .value("Day", DateFormatService.timeFromDate($0.daytime)),
                             y: .value("Temp", $0.temp))
                    .lineStyle(.init(lineWidth: 5))
                    .interpolationMethod(.catmullRom)
                    PointMark(x: .value("Day", DateFormatService.timeFromDate($0.daytime)),
                              y: .value("Temp", $0.temp))
                }
                .foregroundStyle(.linearGradient(Gradient(colors: setupGradient()),
                                                 startPoint: .leading,
                                                 endPoint: .trailing))
                .chartYScale(domain: [minTemp - 3, maxTemp + 3], type: .linear)
            }
        }
        .onAppear {
            print(data)
        }
    }
    
    // MARK: - Private
    
    private func setupGradient() -> [Color] {
        var colors: [Color] = []
        let range = (minTemp...maxTemp)
        if range ~= (-30)...(-15) {
            colors.append(.blue)
        }
        if range ~= (-14)...0 {
            colors.append(.mint)
        }
        if range ~= 1...15 {
            colors.append(.green)
        }
        if range ~= 15...20 {
            colors.append(.yellow)
        }
        if range ~= 21...25 {
            colors.append(.orange)
        }
        if range ~= 26...Int.max {
            colors.append(.red)
        }
        return colors
    }
}
