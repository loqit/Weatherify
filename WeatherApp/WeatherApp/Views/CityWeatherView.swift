import SwiftUI

struct CityWeatherView: View {
    @StateObject private var viewModel: WeatherViewModel = WeatherViewModel()
    var cityElement: CityElement

    var body: some View {
        VStack {
            Spacer()
            Text(cityElement.name)
            if let weatherData = viewModel.weatherData {
                Text("\(Int(weatherData.current.temp))°")
            }
            Spacer()
            ScrollView(.vertical, showsIndicators: false) {
                currentWeatherView
                dailyWeatherViwe
            }
            Spacer()
            Spacer()
        }
        .task {
            await viewModel.load(for: cityElement)
        }
    }
    
    private var currentWeatherView: some View {
        return AnyView(
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.weatherData?.hourly ?? []) { hourly in
                        WeatherCard(temp: String(Int(hourly.temp)),
                                    iconName: hourly.weather[0].icon,
                                    time: DateFormatService.timeFromDate(hourly.dt))
                        
                    }
                }
            }
            .padding()
        )
    }
    
    private var dailyWeatherViwe: some View {
        return AnyView(
            VStack {
                ForEach(viewModel.weatherData?.daily ?? []) { daily in
                    DailyWeather(date: DateFormatService.shortDate(daily.dt),
                                 temp: daily.temp,
                                 iconName: daily.weather[0].icon)
                }
            }
        )
    }
}
