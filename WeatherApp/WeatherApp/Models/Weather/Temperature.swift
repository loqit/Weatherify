import Foundation

struct Temperature: Decodable, Equatable {

    let min, max: Double
    
    init(min: Double, max: Double) {
        self.min = min
        self.max = max
    }
    
    init(_ model: TempEntity?) {
        self.min = model?.min ?? 0
        self.max = model?.max ?? 0
    }
}
