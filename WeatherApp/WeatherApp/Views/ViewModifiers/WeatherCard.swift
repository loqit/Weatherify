import SwiftUI

struct WeatherCard: View {
    
    let temp: String
    let icon: Image?
    let time: String
    
    var body: some View {
        VStack(spacing: 16) {
            Text("\(temp)°")
                .font(.caption)
                .fontWeight(.medium)
            icon?
                .renderingMode(.original)
                .imageScale(.small)
            Text(time)
                .font(.caption)
                .fontWeight(.medium)
        }
        .frame(width: 60, height: 90)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}

struct WeatherCard_Previews: PreviewProvider {
    static var previews: some View {
        WeatherCard(temp: "19", icon: Image(systemName: "sun.min"), time: "12AM")
    }
}
