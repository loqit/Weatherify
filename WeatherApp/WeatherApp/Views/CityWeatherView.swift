import SwiftUI

struct CityWeatherView: View {
  @StateObject private var viewModel: WeatherViewModel = WeatherViewModelCreator().factoryMethod(parser: NetworkParser())
  private let coreDataService = WeatherCoreDataService(dataController: DataController())
  var cityElement: City
  
  var body: some View {
    VStack {
      Spacer()
      HStack {
        Text(cityElement.name)
        Button(action: {},
               label: { Image(systemName: "star") }
        )
        .onTapGesture { Task { coreDataService.save(viewModel.weatherData) } }
      }
      if let weatherData = viewModel.weatherData {
        Text("\(Int(weatherData.current.temp))°")
      }
      Spacer()
      ScrollView(.vertical, showsIndicators: false) {
        currentWeatherView
        dailyWeatherView
      }
      Spacer()
      Spacer()
    }
    .task {
      self.viewModel.city = cityElement
      await viewModel.load()
    }
  }
  
  private var currentWeatherView: some View {
    return AnyView(
      ScrollView(.horizontal, showsIndicators: false) {
        HStack {
          ForEach(viewModel.weatherData?.hourly ?? []) { hourly in
            WeatherCard(temp: String(Int(hourly.temp)),
                        iconName: hourly.weather[0].icon,
                        time: DateFormatService.timeFromDate(hourly.daytime))
            
          }
        }
      }
        .padding()
    )
  }
  
  private var dailyWeatherView: some View {
    return AnyView(
      VStack {
        ForEach(viewModel.weatherData?.daily ?? []) { daily in
          DailyWeather(date: DateFormatService.shortDate(daily.daytime),
                       temp: daily.temp,
                       iconName: daily.weather[0].icon)
        }
      }
    )
  }
}

extension Optional {
    public func `do`(_ action: (Wrapped) -> Void) {
        self.map(action)
    }
    
    public func `do`(_ action: ((Wrapped) -> Void)?) {
        action.do(self.do)
    }
}
