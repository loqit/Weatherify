import SwiftUI

class TempGradinetConfigurator {
    
    static func setupGradient(minTemp: Int, maxTemp: Int) -> [Color] {
        var colors: [Color] = []
        let range = (minTemp...maxTemp)
        if range ~= (-30)...(-15) {
            colors.append(.blue)
        }
        if range ~= (-14)...0 {
            colors.append(.mint)
        }
        if range ~= 1...14 {
            colors.append(.green)
        }
        if range ~= 15...20 {
            colors.append(.yellow)
        }
        if range ~= 21...25 {
            colors.append(.orange)
        }
        if range ~= 26...Int.max {
            colors.append(.red)
        }
        return colors
    }
}
