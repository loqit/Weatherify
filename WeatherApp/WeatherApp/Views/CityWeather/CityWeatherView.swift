import SwiftUI
import ComposableArchitecture
import CoreLocation

struct CityWeatherView: View {

    // MARK: - Properties

    let store: StoreOf<CityWeatherReducer>

    @ObservedObject var weatherViewModel: CityWeatherViewModel
    @State private var offset: CGFloat = 0
    @State private var isChartShown = false

    // MARK: - Body

    // FIXME: View doesn't update at first open
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
                VStack {
                    ScrollView(.vertical, showsIndicators: false) {
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
                        currentWeatherView(hourlyWeather: viewStore.weatherData?.hourly ?? [])
                        dailyWeatherView(dailyWeather: viewStore.weatherData?.daily ?? [],
                                         minWeekly: viewStore.minWeeklyTemp ?? 0,
                                         maxWeekly: viewStore.maxWeeklyTemp ?? 0)
                        uviProgress(progress: viewStore.weatherData?.current.uvi ?? 0)
                            .padding(.vertical, 16)
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
                    viewStore.send(.requestWeather(weatherViewModel.coordinate.latitude, weatherViewModel.coordinate.longitude))
                }
                .sheet(isPresented: $isChartShown) {
                    /// This sheet is temporaly not working. The chart itself working fine
                    WeatherChartView(data: viewStore.weatherData?.hourly ?? [])
                }
            }
        .background(.linearGradient(colors: [.cyan, .blue, .teal], startPoint: .topLeading, endPoint: .bottomTrailing))
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

    private func uviProgress(progress: Double) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .shadow(radius: 25, x: 3, y: 8)
                .padding(.horizontal, 16)
                .foregroundColor(.white)
            VStack {
                CircularProgressBar(progress: progress,
                                    min: 0,
                                    max: 11)
                .padding(.horizontal, 16)
              Text("Ultra Violet Index")
                    .font(.title)
                    .fontWeight(.bold)
                    .offset(y: -35)
            }
            .padding(16)
        }
        .frame(height: 250)
        .padding(.top, 10)
     //   .background(.ultraThinMaterial)
    }

    private func currentWeatherView(hourlyWeather: [CurrentWeather]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(hourlyWeather) { hourly in
                    Button {
                        isChartShown = true
                    } label: {
                        HourlyWeather(temp: String(Int(hourly.temp)),
                                    iconName: hourly.weather[0].icon,
                                    time: DateFormatService.timeFromDate(hourly.daytime))
                        .shadow(radius: 5, x: 5, y: 5)
                        .tint(.black)
                    }
                }
            }
            .padding()
        }
        .padding()
    }

    private func dailyWeatherView(dailyWeather: [DailyWeatherModel],
                                  minWeekly: Double,
                                  maxWeekly: Double) -> some View {
        VStack {
            ForEach(dailyWeather) { daily in
                DailyWeather(dailyModel: .init(dailyWeather: daily,
                                               minWeekly: minWeekly,
                                               maxWeekly: maxWeekly))
            }
        }
        .padding()
    }
}
