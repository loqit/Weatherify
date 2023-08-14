import SwiftUI

struct CityCard: View {
    
    // MARK: - Propertie

    let cityName: String
    let cityState: String
    let cityCountry: String

    // MARK: - Body

    var body: some View {
        HStack {
            cityTitle
            Spacer()
            saveButton
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
    
    // MARK: - Private
    
    private var cityTitle: some View {
        VStack(alignment: .leading) {
            Text(cityName)
                .font(.title3)
                .fontWeight(.bold)
            Text("\(cityState) \(cityCountry)")
                .font(.subheadline)
                .fontWeight(.light)
        }
        .tint(.black)
        .frame(minWidth: 150, maxWidth: 200, alignment: .leading)
        .padding()
    }
    
    private var saveButton: some View {
        Button(action: {},
               label: {
                Image(systemName: "star")
                .tint(.yellow)
                .fontWeight(.bold)
            }
        )
    }

}

struct CityCard_Previews: PreviewProvider {
    
    static var previews: some View {
        CityCard(cityName: "Minsk", cityState: "Minsk", cityCountry: "Belarus")
    }
}
