import SwiftUI
import ComposableArchitecture

struct CityWeatherView: View {

    private let coreDataService = WeatherCoreDataService(dataController: CoreDataController())
    let store: StoreOf<CityWeatherReducer>
    var cityElement: City?

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Spacer()
                HStack {
                    Text(cityElement?.name ?? "City Name")
                    Button(action: {
                        coreDataService.save(viewStore.weatherData)
                    },
                           label: { Image(systemName: "star") }
                    )
                }
                if let currentTemp = viewStore.weatherData?.current.temp {
                    Text("\(Int(currentTemp))")
                }
                Spacer()
                ScrollView(.vertical, showsIndicators: false) {
                    currentWeatherView(hourlyWeather: viewStore.weatherData?.hourly ?? [])
                    dailyWeatherView(dailyWeather: viewStore.weatherData?.daily ?? [])
                }
                Spacer()
                Spacer()
            }
            .onAppear {
                guard let lat = cityElement?.lat,
                      let lon = cityElement?.lon else {
                    return
                }
                viewStore.send(.requestWeather(lat, lon))
            }
        }
    }
    
    // MARK: - Private
    
    private func currentWeatherView(hourlyWeather: [CurrentWeather]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(hourlyWeather) { hourly in
                    WeatherCard(temp: String(Int(hourly.temp)),
                                iconName: hourly.weather[0].icon,
                                time: DateFormatService.timeFromDate(hourly.daytime))
                    
                }
            }
        }
            .padding()
    }
    
    private func dailyWeatherView(dailyWeather: [DailyWeatherModel]) -> some View {
        VStack {
            ForEach(dailyWeather) { daily in
                DailyWeather(date: DateFormatService.shortDate(daily.daytime),
                             temp: daily.temp,
                             iconName: daily.weather[0].icon)
            }
        }
    }
}
