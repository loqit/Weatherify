import SwiftUI
import ComposableArchitecture
import CoreLocation

struct CityWeatherView: View {

    // MARK: - Properties

    let store: StoreOf<CityWeatherReducer>

    let coordinate: CLLocationCoordinate2D
    let cityName: String
    
    @State var offset: CGFloat = 0
    @State var isChartShown = false

    // MARK: - Body

    // FIXME: View doesn't update at first open
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                CircularProgressBar(progress: viewStore.weatherData?.current.pressure ?? 1,
                                    weekDelta: viewStore.pressureDelta ?? 1,
                                    weeklyMin: viewStore.minWeeklyPressure ?? 1)
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
                    Button {
                        isChartShown = true
                    } label: {
                        chartButton
                    }
                    dailyWeatherView(dailyWeather: viewStore.weatherData?.daily ?? [],
                                     minWeekly: viewStore.minWeeklyTemp ?? 0,
                                     maxWeekly: viewStore.maxWeeklyTemp ?? 0)
                }
            }
            .toolbar(.hidden, for: .tabBar)
            .overlay {
                if viewStore.isWeatherRequestInFlight {
                    ProgressView()
                }
            }
            .onDisappear {
                print("Disappear")
            }
            .onAppear {
                print("Appear")
                viewStore.send(.requestWeather(coordinate.latitude, coordinate.longitude))
            }
            .sheet(isPresented: $isChartShown) {
                /// This sheet is temporaly not working. The chart itself working fine
                WeatherChartView(data: viewStore.weatherData?.hourly ?? [])
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
                    .shadow(radius: 5, x: 5, y: 5)
                    
                }
            }
            .padding()
        }
            .padding()
    }
    
    private var chartButton: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(.white)
                .shadow(radius: 15, x: 5, y: 5)
                .frame(height: 40)
                .padding()
            Text("Show Charts")
        }
    }
    
    private func dailyWeatherView(dailyWeather: [DailyWeatherModel],
                                  minWeekly: Double,
                                  maxWeekly: Double) -> some View {
        VStack {
            ForEach(dailyWeather) { daily in
                DailyWeather(date: daily.daytime,
                             temp: daily.temp,
                             iconName: daily.weather[0].icon,
                             minWeekly: minWeekly,
                             maxWeekly: maxWeekly)
            }
        }
        .padding()
    }
}
