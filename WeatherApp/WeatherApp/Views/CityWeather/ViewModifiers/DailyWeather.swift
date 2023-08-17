import SwiftUI

struct DailyWeather: View {
    
    // MARK: - Properties

    let date: Double
    let temp: Temperature
    let iconName: String
    let maxWeekly: Double
    let minWeekly: Double
    
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
        .background(Color(.secondarySystemBackground))
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
                            .frame(width: proxy.size.width / (temp.min - minWeekly))
                        Capsule()
                            .fill(.linearGradient(colors: [.mint, .green, .yellow, .orange, .red],
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
        DailyWeather(date: 1.0, temp: Temperature(min: 16, max: 25), iconName: "", maxWeekly: 30, minWeekly: 13)
    }
}
