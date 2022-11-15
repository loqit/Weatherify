import Foundation

protocol ViewModelCreator {
  associatedtype ViewModel: ViewModelProtocol
  func factoryMethod(parser: NetworkParserProtocol) -> ViewModel
}

class WeatherViewModelCreator: ViewModelCreator {
  typealias ViewModel = WeatherViewModel
  func factoryMethod(parser: NetworkParserProtocol) -> ViewModel {
    let networkService = NetworkService(parser: parser)
    return WeatherViewModel(service: WeatherService(service: networkService))
  }
}

class CitiesViewModelCreator: ViewModelCreator {
  typealias ViewModel = CitiesViewModel
  func factoryMethod(parser: NetworkParserProtocol) -> ViewModel {
    let networkService = NetworkService(parser: parser)
    return CitiesViewModel(service: CityService(service: networkService))
  }
}

class CountriesViewModelCreator: ViewModelCreator {
  typealias ViewModel = CountriesViewModel
  func factoryMethod(parser: NetworkParserProtocol) -> ViewModel {
    let networkService = NetworkService(parser: parser)
    return CountriesViewModel(service: CountryService(service: networkService))
  }
}
