import SwiftUI

struct CityWeatherView: View {
    @StateObject private var viewModel: WeatherViewModel = WeatherViewModel()
    var cityElement: CityElement

    var body: some View {
        VStack {
            Spacer()
            Text(cityElement.name)
            if !viewModel.weatherData.isEmpty {
                Text("\(Int(viewModel.weatherData[0].main.temp))°")
            }
            Spacer()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.weatherData) { hourly in
                        WeatherCard(temp: String(Int(hourly.main.temp)), icon: nil, time: timeFromDate(hourly.id))
                    }
                }
            }
            .padding()
            Spacer()
            Spacer()
        }
        .task {
            
            await viewModel.load(for: cityElement)
        }
    }
    
    private func timeFromDate(_ dateInterval: Double) -> String {
        let date = Date(timeIntervalSince1970: dateInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
        
    }
}
