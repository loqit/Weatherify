import Foundation

protocol ViewModelCreator {
    associatedtype ViewModel: ViewModelProtocol
    func factoryMethod(parser: NetworkParserProtocol) -> ViewModel
}

class WeatherViewModelCreator: ViewModelCreator {
    typealias ViewModel = WeatherViewModel
    func factoryMethod(parser: NetworkParserProtocol) -> ViewModel {
        return WeatherViewModel(service: WeatherService(service: NetworkService(parser: parser)))
    }
}

class CitiesViewModelCreator: ViewModelCreator {
    typealias ViewModel = CitiesViewModel
    func factoryMethod(parser: NetworkParserProtocol) -> ViewModel {
        return CitiesViewModel(service: CityService(service: NetworkService(parser: parser)))
    }
}

class CountriesViewModelCreator: ViewModelCreator {
    typealias ViewModel = CountriesViewModel
    func factoryMethod(parser: NetworkParserProtocol) -> ViewModel {
        return CountriesViewModel(service: CountryService(service: NetworkService(parser: parser)))
    }
}
