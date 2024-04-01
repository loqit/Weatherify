import SwiftUI

struct DailyWeather: View {

    // MARK: - Properties

    @ObservableObject var dailyModel: DailyWeatherModel

    // MARK: - Body

    var body: some View {
        HStack {
            Text(DateFormatService.dayOfWeek(date))
                .fontWeight(.medium)
                .frame(minWidth: 75, alignment: .leading)
            Spacer()
            tempProgress
            weatherIcon
        }
        .padding(.horizontal)
        .padding(.vertical, 22)
        .background(.ultraThinMaterial)
        .cornerRadius(25)
    }

    // MARK: - Private

    private var tempProgress: some View {
        HStack {
            Text("\(Int(dailyModel.temp.min))°C")
                .font(.caption)
                .fontWeight(.light)
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(.tertiary)
                    .foregroundColor(.gray)
                GeometryReader { proxy in
                    HStack(spacing: 0) {
                        Capsule()
                            .fill(.clear)
                            .frame(width: getClearCaplsuleWidthModifier() * proxy.size.width)
                        Capsule()
                            .fill(getWeatherGradient(temp: dailyModel.temp))
                            .frame(width: getGradientCaplsuleWidthModifier() * proxy.size.width)
                    }
                }
            }
            .frame(height: 4)
            Text("\(Int(dailyModel.temp.max))°C")
                .font(.caption)
                .fontWeight(.light)
        }
    }

    private var weatherIcon: some View {
        AsyncImage(url: OpenWeatherEndpoint.iconUrl(dailyModel.iconName).url) { image in
            image
                .resizable()
        } placeholder: {
            ProgressView()
        }
        .imageScale(.small)
        .frame(width: 40, height: 40)
    }

    private func getGradientCaplsuleWidthModifier() -> Double {
        (dailyModel.temp.max - dailyModel.temp.min) / (dailyModel.maxWeekly - dailyModel.minWeekly)
    }

    private func getWeatherGradient(temp: Temperature) -> LinearGradient {
        LinearGradient(colors: TempGradinetConfigurator.setupGradient(temp: temp),
                       startPoint: .leading,
                       endPoint: .trailing)
    }

    private func getClearCaplsuleWidthModifier() -> Double {
        (dailyModel.temp.min - dailyModel.minWeekly) / (dailyModel.maxWeekly - dailyModel.minWeekly)
    }
}
