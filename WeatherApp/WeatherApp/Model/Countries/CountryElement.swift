import Foundation

struct CountryElement: Codable {
    let name: Name
    let tld: [String]?
    let cca2: String
    let ccn3: String?
    let cca3: String
    let cioc: String?
    let independent: Bool?
    let status: String
    let unMember: Bool
    let currencies: String?
    let idd: Idd
    let capital: [String]?
    let altSpellings: [String]
    let region: String
    let subregion: String?
    let languages: [String: String]?
    let translations: [String: Translation]
    let latlng: [Double]
    let landlocked: Bool
    let borders: [String]?
    let area: Double
    let demonyms: String?
    let flag: String
    let maps: Maps
    let population: Int
    let fifa: String?
    let car: Car
    let timezones: [String]
    let continents: [String]
    let flags, coatOfArms: CoatOfArms
    let startOfWeek: String
    let capitalInfo: CapitalInfo
    let postalCode: PostalCode?
    let gini: [String: Double]?
}
