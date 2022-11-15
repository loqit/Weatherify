import SwiftUI

struct CountryCard: View {
  
  let coreDataService = CountryCoreDataService(dataController: DataController())
  
  let countryName: String
  let countryFlag: URL?
  
  var body: some View {
    HStack {
      Text(countryName)
        .font(.headline)
        .fontWeight(.bold)
        .padding()
      Spacer()
      AsyncImage(url: countryFlag) { image in
        image
          .resizable()
      } placeholder: {
        ProgressView()
      }
      .aspectRatio(contentMode: .fit)
      .background(Color(.secondarySystemBackground))
      .imageScale(.medium)
      .frame(width: 40, height: 40)
      Button(action: {
        
      }, label: {
        Image(systemName: "square.and.arrow.down")
      })
      .onTapGesture {
        Task {
          await coreDataService.save(by: countryName, and: UUID())
        }
      }
    }
    .padding()
    .background(Color(.secondarySystemBackground))
    .cornerRadius(10)

  }
}

struct CountryCard_Previews: PreviewProvider {
  static var previews: some View {
    CountryCard(countryName: "Italy", countryFlag: URL(string: "https://flagcdn.com/w320/it.png"))
  }
}
