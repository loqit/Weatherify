import SwiftUI

struct DailyWeather: View {
    
    // MARK: - Properties

    let date: Double
    let temp: Temperature
    let iconName: String
    
    // MARK: - Body

    var body: some View {
        HStack {
            Text(DateFormatService.dayOfWeek(date))
                .fontWeight(.medium)
            Spacer()
            Text("\(Int(temp.min))°C/\(Int(temp.max))°C")
                .font(.caption)
                .fontWeight(.light)
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
    
}
