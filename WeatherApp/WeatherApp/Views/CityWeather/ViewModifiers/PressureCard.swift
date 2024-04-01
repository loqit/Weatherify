import SwiftUI

struct PressureCard: View {
    
    @State var progressValue: Float
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var degress: Double = -110
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
            
        }
    }
}
