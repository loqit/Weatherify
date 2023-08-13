import SwiftUI

struct HourlyWeather: View {
    
    // MARK: - Properties

    let temp: String
    let iconName: String
    let time: String
    
    // MARK: - Body

    var body: some View {
        VStack(spacing: 16) {
            timeTitle
            weatherImage
            tempTitle
        }
        .frame(width: 60, height: 90)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
    
    // MARK: - Private
    
    private var tempTitle: some View {
        Text("\(temp)°C")
            .font(.caption)
            .fontWeight(.medium)
    }

    private var weatherImage: some View {
        AsyncImage(url: OpenWeatherEndpoint.iconUrl(iconName).url) { image in
            image
                .resizable()
        } placeholder: {
            ProgressView()
        }
        .imageScale(.small)
        .frame(width: 40, height: 40)
    }
    
    private var timeTitle: some View {
        Text(time)
            .font(.caption)
            .fontWeight(.medium)
    }
}

struct WeatherCard_Previews: PreviewProvider {
    
    static var previews: some View {
        HourlyWeather(temp: "20", iconName: "", time: "2:00 PM")
    }
}
