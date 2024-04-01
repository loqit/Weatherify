import SwiftUI
import Combine

struct HourlyWeather: View {

    // MARK: - Properties

    @ObservedObject var model: HourlyWeatherModel

    // MARK: - Body

    var body: some View {
        VStack(spacing: 16) {
            timeTitle
            weatherImage
            tempTitle
        }
        .frame(width: 60, height: 90)
        .padding()
        .background(model.time == "Now" ? .thinMaterial : .ultraThinMaterial)
        .cornerRadius(20)
    }
    
    // MARK: - Private
    
    private var tempTitle: some View {
        Text("\(model.temp)°C")
            .font(.caption)
            .fontWeight(.medium)
    }

    private var weatherImage: some View {
        AsyncImage(url: OpenWeatherEndpoint.iconUrl(model.iconName).url) { image in
            image
                .resizable()
        } placeholder: {
            ProgressView()
        }
        .imageScale(.small)
        .frame(width: 40, height: 40)
    }

    private var timeTitle: some View {
        Text(model.time)
            .font(.caption)
            .fontWeight(.medium)
    }
}
