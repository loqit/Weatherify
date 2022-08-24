import SwiftUI

struct CountryCard: View {

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
                .imageScale(.small)
                .frame(width: 40, height: 40)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}

struct CountryCard_Previews: PreviewProvider {
    static var previews: some View {
        CountryCard(countryName: "Italy", countryFlag: URL(string: "https://flagcdn.com/w320/it.png"))
            .previewInterfaceOrientation(.landscapeRight)
    }
}
