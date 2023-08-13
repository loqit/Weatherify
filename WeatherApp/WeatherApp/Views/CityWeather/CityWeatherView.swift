import SwiftUI
import ComposableArchitecture
import CoreLocation

struct CityWeatherView: View {

    // MARK: - Properties

    let store: StoreOf<CityWeatherReducer>

    private let coreDataService = WeatherCoreDataService(dataController: CoreDataController())
    let coordinate: CLLocationCoordinate2D
    let cityName: String

    // MARK: - Body

    // FIXME: View doesn't update at first open
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Spacer()
                cityTitle
                if let currentWeather = viewStore.weatherData?.current {
                    currentTempTitle(currentTemp: currentWeather.temp)
                    Spacer()
                    descriptionTitle(description: currentWeather.weather[0].weatherDescription)
                }
                Spacer()
                if let todayTemps = viewStore.weatherData?.daily[0].temp {
                    todayTemp(minTemp: todayTemps.min, maxTemp: todayTemps.max)
                }
                Spacer()
                ScrollView(.vertical, showsIndicators: false) {
                    currentWeatherView(hourlyWeather: viewStore.weatherData?.hourly ?? [])
                    dailyWeatherView(dailyWeather: viewStore.weatherData?.daily ?? [])
                }
                Spacer(minLength: 7)
            }
            .overlay {
                if viewStore.isWeatherRequestInFlight {
                    ProgressView()
                }
            }
            .onAppear {
                viewStore.send(.requestWeather(coordinate.latitude, coordinate.longitude))
            }
        }
    }
    
    // MARK: - Private
    
    private var cityTitle: some View {
        Text(cityName)
            .font(.title)
            .fontWeight(.medium)
    }
    
    private func descriptionTitle(description: String) -> some View {
        Text(description.capitalized)
    }
    
    private func todayTemp(minTemp: Double, maxTemp: Double) -> some View {
        Text("Min: \(Int(minTemp))°C Max: \(Int(maxTemp))°C")
            .font(.headline)
            .fontWeight(.medium)
    }
    
    private func currentTempTitle(currentTemp: Double) -> some View {
        Text("\(Int(currentTemp))°C")
            .font(.largeTitle) // TODO: Make it bigger
            .fontWeight(.medium)
    }
    
    private func currentWeatherView(hourlyWeather: [CurrentWeather]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(hourlyWeather) { hourly in
                    HourlyWeather(temp: String(Int(hourly.temp)),
                                iconName: hourly.weather[0].icon,
                                time: DateFormatService.timeFromDate(hourly.daytime))
                    
                }
            }
            .padding()
        }
            .padding()
    }
    
    private func dailyWeatherView(dailyWeather: [DailyWeatherModel]) -> some View {
        VStack {
            ForEach(dailyWeather) { daily in
                DailyWeather(date: daily.daytime,
                             temp: daily.temp,
                             iconName: daily.weather[0].icon)
            }
        }
        .padding()
    }
}
