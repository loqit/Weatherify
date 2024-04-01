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
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    if let currentWeather = viewStore.weatherData?.current {
                        todayWeatherBlock(currentWeather: currentWeather)
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
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .offset(y: UIScreen.main.bounds.height * -0.03)
            }
            .toolbar(.hidden, for: .tabBar)
            .overlay {
                if viewStore.isWeatherRequestInFlight {
                    ProgressView()
                }
            }
            .onAppear {
                viewStore.send(.requestWeather(weatherViewModel.coordinate.latitude,
                                               weatherViewModel.coordinate.longitude))
            }
            .sheet(isPresented: $isChartShown) {
                WeatherChartView(chartModel: .init(data: viewStore.weatherData?.hourly ?? []))
            }
            .background { backgroundGradient.ignoresSafeArea() }
        }
    }

    // MARK: - Private

    private var backgroundGradient: LinearGradient {
        LinearGradient(
            stops: [
                .init(color: .init(hex: "FEE3BC"), location: 0.01),
                .init(color: .init(hex: "F39876"), location: 0.5)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private func todayWeatherBlock(currentWeather: CurrentWeather) -> some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("\(weatherViewModel.cityName),")
                    .font(.custom("Inter-Medium", size: 27))
                Text(weatherViewModel.country)
                    .font(.custom("Inter-Medium", size: 27))
                Text("Tue, Jun 30")
                    .font(.custom("Inter-Regular", size: 15))
                    .foregroundStyle(Color(hex: "9A938C"))
            }
            Spacer()
            HStack {
                // TODO: - Remove mock data
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Text("\(Int(currentWeather.temp))")
                            .font(.custom("Inter-Bold", size: 70))
                        Text("°C")
                            .font(.custom("Inter-Light", size: 17))
                    }
                    Text(currentWeather.weather[0].weatherDescription)
                        .font(.custom("Inter-Regular", size: 20))
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .overlay(alignment: .leading) {
                    Image("sunny_cloudy")
                        .resizable()
                        .scaledToFit()
                }
            }
            .padding()
        }
        .frame(maxWidth: UIScreen.main.bounds.width * 0.8, alignment: .top)
    }

    private func todayTemp(minTemp: Double, maxTemp: Double) -> some View {
        Text("Min: \(Int(minTemp))°C Max: \(Int(maxTemp))°C")
            .font(.custom("Inter-Medium", size: 15))
    }

    private func currentWeatherView(hourlyWeather: [CurrentWeather]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(hourlyWeather) { hourly in
                    Button {
                        isChartShown = true
                    } label: {
                        HourlyWeather(model: .init(hourly: hourly))
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
