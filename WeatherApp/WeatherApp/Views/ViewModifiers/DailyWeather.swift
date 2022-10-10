import SwiftUI

struct DailyWeather: View {
    let date: String
    let temp: Temperature
    let iconName: String
    
    var body: some View {
        HStack {
            Text(date)
                .fontWeight(.medium)
            Spacer()
            Text("\(Int(temp.min))°/\(Int(temp.max))°")
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
