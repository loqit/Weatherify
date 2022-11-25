import SwiftUI

struct CityCard: View {
  
  let cityInfo: City
  
  private let coreDataService = CityCoreDataService(dataController: DataController())
  
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
      Button(action: {},
             label: { Image(systemName: "star") }
      )
      .onTapGesture { Task { coreDataService.save(cityInfo) } }
    }
    .padding()
    .background(Color(.secondarySystemBackground))
    .cornerRadius(10)
  }
}
