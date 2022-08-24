import Foundation

struct CountryElement: Codable, Identifiable {
    var id: UUID { UUID() }
    let name: Name
    let flags, coatOfArms: CoatOfArms
}
