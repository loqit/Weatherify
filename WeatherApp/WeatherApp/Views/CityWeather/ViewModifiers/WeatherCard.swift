import SwiftUI

struct WeatherCard: View {
    
    let temp: String
    let iconName: String
    let time: Double
    
    var body: some View {
        VStack(spacing: 16) {
            Text("\(temp)°C")
                .font(.caption)
                .fontWeight(.medium)
            AsyncImage(url: OpenWeatherEndpoint.iconUrl(iconName).url) { image in
                image
                    .resizable()
            } placeholder: {
                ProgressView()
            }
            .imageScale(.small)
            .frame(width: 40, height: 40)
            Text(DateFormatService.timeFromDate(time))
                .font(.caption)
                .fontWeight(.medium)
        }
        .frame(width: 60, height: 90)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}
