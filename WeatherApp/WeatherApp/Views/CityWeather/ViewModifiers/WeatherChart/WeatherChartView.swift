import SwiftUI
import Charts

struct WeatherChartView: View {

    // MARK: - Properties

    @ObservedObject var chartModel: WeatherChartViewModel

    // MARK: - Body

    var body: some View {
        ZStack {
            List {
                Chart(chartModel.data) {
                    LineMark(x: .value("Day", DateFormatService.timeFromDate($0.daytime)),
                             y: .value("Temp", $0.temp))
                    .lineStyle(.init(lineWidth: 5))
                    .interpolationMethod(.catmullRom)
                    PointMark(x: .value("Day", DateFormatService.timeFromDate($0.daytime)),
                              y: .value("Temp", $0.temp))
                }
                .foregroundStyle(getGradient())
                .chartYScale(domain: [chartModel.minTemp - 3, chartModel.maxTemp + 3], type: .linear)
            }
        }
        .onAppear {
            print(chartModel.data)
        }
    }

    // MARK: - Private

    private func getGradient() -> LinearGradient {
        LinearGradient(colors: TempGradinetConfigurator.setupGradient(minTemp: chartModel.minTemp,
                                                                      maxTemp: chartModel.maxTemp),
                       startPoint: .leading,
                       endPoint: .trailing)
    }
}
