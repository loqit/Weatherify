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
                            .frame(width: proxy.size.width * (temp.min - minWeekly) / (maxWeekly - minWeekly))
                        Capsule()
                            .fill(.linearGradient(colors: setupGradient(),
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
    
    // MARK: - Private
    
    private func setupGradient() -> [Color] {
        var colors: [Color] = []
        let range = (Int(temp.min)...Int(temp.max))
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
        print(colors)
        return colors
    }
}

struct DailyWeather_Previews: PreviewProvider {
    
    static var previews: some View {
        DailyWeather(date: 1.0, temp: Temperature(min: 12, max: 22), iconName: "", maxWeekly: 29, minWeekly: 12)
    }
}
