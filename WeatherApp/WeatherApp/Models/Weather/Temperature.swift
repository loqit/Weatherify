import Foundation

struct Temperature: Decodable, Equatable {

    let min, max: Double
    
    init(_ model: TempEntity?) {
        self.min = model?.min ?? 0
        self.max = model?.max ?? 0
    }
}
