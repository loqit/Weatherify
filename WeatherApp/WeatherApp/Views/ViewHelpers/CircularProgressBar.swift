import SwiftUI

struct CircularProgressBar: View {
    
    @State var progress: Int
    var weekMax: Int
    
    init(progress: Int, weekMax: Int) {
        self.progress = progress
        self.weekMax = weekMax
        print("Pressure \(progress) max \(weekMax)")
    }

    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.3, to: 0.9)
                .stroke(style: StrokeStyle(lineWidth: 12.0, lineCap: .round, lineJoin: .round))
                .opacity(0.3)
                .foregroundColor(Color.gray)
                .rotationEffect(.degrees(54.5))
            Circle()
                .trim(from: 0.3, to: 0.6 * CGFloat(progress / weekMax))
                .stroke(style: StrokeStyle(lineWidth: 12.0, lineCap: .round, lineJoin: .round))
                .fill(.green)
                .rotationEffect(.degrees(54.5))
        }
    }

    struct ProgressBarTriangle: View {
        @Binding var progress: Float

        var body: some View {
            ZStack {
                Image("triangle").resizable().frame(width: 10, height: 10, alignment: .center)
            }
        }
    }
}

struct CircularProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressBar(progress: 10, weekMax: 50)
    }
}
