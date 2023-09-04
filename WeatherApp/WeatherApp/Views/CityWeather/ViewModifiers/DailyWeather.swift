import SwiftUI

struct DailyWeather: View {
    
    // MARK: - Properties

    let date: Double
    let temp: Temperature
    let iconName: String
    let minWeekly: Double
    let maxWeekly: Double
    
    // MARK: - Body

    var body: some View {
        HStack {
            Text(DateFormatService.dayOfWeek(date))
                .fontWeight(.medium)
                .frame(minWidth: 75, alignment: .leading)
            Spacer()
            tempProgress
            AsyncImage(url: OpenWeatherEndpoint.iconUrl(iconName).url) { image in
                image
                    .resizable()
            } placeholder: {
                ProgressView()
            }
            .imageScale(.small)
            .frame(width: 40, height: 40)
        }
        .padding(.horizontal)
        .padding(.vertical, 22)
        .background(.ultraThinMaterial)
        .cornerRadius(10)
    }
    
    // MARK: - Private

    private var tempProgress: some View {
        HStack {
            Text("\(Int(temp.min))°C")
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
                            .frame(width: proxy.size.width * (temp.min - minWeekly) / (maxWeekly - minWeekly))
                        Capsule()
                            .fill(.linearGradient(colors: TempGradinetConfigurator.setupGradient(minTemp: Int(temp.min),
                                                                                                 maxTemp: Int(temp.max)),
                                                  startPoint: .leading,
                                                  endPoint: .trailing))
                            .frame(width: (temp.max - temp.min) / (maxWeekly - minWeekly) * proxy.size.width)
                    }
                }

            }
            .frame(height: 4)
            Text("\(Int(temp.max))°C")
                .font(.caption)
                .fontWeight(.light)
        }
    }
}

struct DailyWeather_Previews: PreviewProvider {
    
    static var previews: some View {
        DailyWeather(date: 1.0, temp: Temperature(min: 12, max: 22), iconName: "", minWeekly: 12, maxWeekly: 29)
    }
}
