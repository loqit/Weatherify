import SwiftUI
import ComposableArchitecture

struct CityWeatherView: View {

    // MARK: - Properties

    let store: StoreOf<CityWeatherReducer>

    private let coreDataService = WeatherCoreDataService(dataController: CoreDataController())
    var cityElement: City?
    @State var isCitySaved: Bool = false

    // MARK: - Body

    // FIXME: View not updates at first open
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Spacer()
                
                HStack {
                    VStack {
                        cityTitle
                        if let currentTemp = viewStore.weatherData?.current.temp {
                            currentTempTitle(currentTemp: currentTemp)
                        }
                    }
                    saveButton(weatherData: viewStore.weatherData) // TODO: Pin it to top
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
                guard let lat = cityElement?.lat,
                      let lon = cityElement?.lon else {
                    return
                }
                viewStore.send(.requestWeather(lat, lon))
            }
        }
    }
    
    // MARK: - Private
    
    private var cityTitle: some View {
        Text(cityElement?.name ?? "City Name")
            .font(.title)
            .fontWeight(.medium)
    }
    
    private func currentTempTitle(currentTemp: Double) -> some View {
        Text("\(Int(currentTemp))°C")
            .font(.largeTitle) // TODO: Make it bigger
            .fontWeight(.medium)
    }
    
    private func saveButton(weatherData: WeatherModel?) -> some View {
        Button(action: {
            coreDataService.save(weatherData)
        },
        label: {
                Image(systemName: isCitySaved ? "star.fill" : "star")
                    .tint(.yellow)
                    .fontWeight(.bold)
            }
        )
    }
    
    private func currentWeatherView(hourlyWeather: [CurrentWeather]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(hourlyWeather) { hourly in
                    WeatherCard(temp: String(Int(hourly.temp)),
                                iconName: hourly.weather[0].icon,
                                time: hourly.daytime)
                    
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
