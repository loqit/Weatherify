import SwiftUI

enum RootTab: Int {
    
    case first, second
    
    var selectedColor: Color {
        switch self {
        case .first:
            return .red
        case .second:
            return .green
        }
    }
}
