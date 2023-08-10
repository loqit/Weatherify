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
                    Text(cityElement?.name ?? "City Name")
                        .font(.largeTitle)
                        .fontWeight(.black)
                    Button(action: {
                        coreDataService.save(viewStore.weatherData)
                    },
                    label: { 
                            Image(systemName: isCitySaved ? "star.fill" : "star") 
                                .tint(.yellow)
                                .fontWeight(.bold)
                        }
                    )
                }
                if let currentTemp = viewStore.weatherData?.current.temp {
                    Text("\(Int(currentTemp))")
                        .font(.title2)
                        .fontWeight(.medium)
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
    
    private func currentWeatherView(hourlyWeather: [CurrentWeather]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(hourlyWeather) { hourly in
                    WeatherCard(temp: String(Int(hourly.temp)),
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
                DailyWeather(date: DateFormatService.shortDate(daily.daytime),
                             temp: daily.temp,
                             iconName: daily.weather[0].icon)
            }
        }
        .padding()
    }
}
