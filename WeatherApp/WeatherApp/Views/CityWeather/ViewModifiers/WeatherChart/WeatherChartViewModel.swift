import Foundation
import Combine

final class WeatherChartViewModel: ObservableObject {
    @Published var data: [CurrentWeather]
    @Published var minTemp: Int
    @Published var maxTemp: Int

    init(data: [CurrentWeather]) {
        self.data = data
        self.minTemp = Int(data.map { $0.temp }.min() ?? 0)
        self.maxTemp = Int(data.map { $0.temp }.max() ?? 0)
    }
}
