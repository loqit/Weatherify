import SwiftUI

struct CircularProgressBar: View {
    
    @State var progress: Int
    var weekDelta: Int
    var weeklyMin: Int
    
    init(progress: Int, weekDelta: Int, weeklyMin: Int) {
        self.progress = progress
        self.weekDelta = weekDelta
        self.weeklyMin = weeklyMin
        print("Pressure \(progress - weeklyMin) max \(weekDelta) Pos \( Double((progress - weeklyMin) / weekDelta))")
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
                .trim(from: 0.3, to: 0.9 * CGFloat(progress / weeklyMin))
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
