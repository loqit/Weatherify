import SwiftUI

struct CircularProgressBar: View {

    // MARK: - Properties

    let progress: Double
    let min: Double
    let max: Double

    // MARK: - Body

    var body: some View {
        ZStack {
                Circle()
                    .trim(from: 0.3, to: 0.9)
                    .stroke(style: StrokeStyle(lineWidth: 12.0, lineCap: .round, lineJoin: .round))
                    .opacity(0.3)
                    .foregroundColor(Color.gray)
                    .rotationEffect(.degrees(54.5))
                Circle()
                    .trim(from: 0.3, to: (0.3 + 0.6 * (progress / (max - min))).round(to: 2))
                    .stroke(style: StrokeStyle(lineWidth: 12.0, lineCap: .round, lineJoin: .round))
                    .fill(AngularGradient(gradient: Gradient(stops: [
                        .init(color: .green, location: 0.39),
                        .init(color: .yellow, location: 0.59),
                        .init(color: .red, location: 0.72),
                        .init(color: .purple, location: 0.8)
                    ]), center: .center))
                    .rotationEffect(.degrees(54.5))
            Text("\(Int(progress))")
                .font(.largeTitle)
                .fontWeight(.bold)
        }
    }
}
