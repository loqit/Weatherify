import SwiftUI

struct CityWeatherView: View {
    
    // MARK: - Properties

    @StateObject private var viewModel: WeatherViewModel = WeatherViewModelCreator().factoryMethod(parser: NetworkParser())
    @State var isCitySaved: Bool = false
    
    private let coreDataService = WeatherCoreDataService(dataController: CoreDataController())
    var cityElement: City?
    
    // MARK: - Body

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text(cityElement?.name ?? "City Name")
                    .font(.largeTitle)
                    .fontWeight(.black)
                Button(action: {
                    coreDataService.save(viewModel.weatherData)
                },
                label: {
                    Image(systemName: isCitySaved ? "star.fill" : "star")
                        .tint(.yellow)
                        .fontWeight(.bold)
                    }
                )
            }
            Spacer()
            if let weatherData = viewModel.weatherData {
                Text("\(Int(weatherData.current.temp))°")
                    .font(.title2)
                    .fontWeight(.medium)
            }
            Spacer()
            ScrollView(.vertical, showsIndicators: false) {
                currentWeatherView
                dailyWeatherView
            }
            Spacer(minLength: 7)
        }
        .task {
            self.viewModel.city = cityElement
            await viewModel.load()
        }
    }
    
    // MARK: - Private
    
    private var currentWeatherView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(viewModel.weatherData?.hourly ?? []) { hourly in
                    WeatherCard(temp: String(Int(hourly.temp)),
                                iconName: hourly.weather[0].icon,
                                time: DateFormatService.timeFromDate(hourly.daytime))
                    
                }
            }
            .padding()
        }
            .padding()
    }
    
    private var dailyWeatherView: some View {
        VStack {
            ForEach(viewModel.weatherData?.daily ?? []) { daily in
                DailyWeather(date: DateFormatService.shortDate(daily.daytime),
                             temp: daily.temp,
                             iconName: daily.weather[0].icon)
            }
        }
        .padding()
    }
}
