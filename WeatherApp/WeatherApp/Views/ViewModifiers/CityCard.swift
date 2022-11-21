import SwiftUI

struct CityCard: View {
  
  let cityInfo: City
  
  var body: some View {
    HStack {
      VStack {
        Text(cityInfo.name)
          .font(.headline)
          .fontWeight(.bold)
        Text("\(cityInfo.state ?? ""), \(cityInfo.country)")
          .font(.caption)
          .fontWeight(.light)
      }
      .padding()
      Spacer()
    }
    .padding()
    .background(Color(.secondarySystemBackground))
    .cornerRadius(10)
  }
}
