import SwiftUI

struct CountryCard: View {

    // MARK: - Properties

    let countryName: String
    let countryFlag: URL?
    
    // MARK: - Body

    var body: some View {
        HStack {
            countryNameTitle
            Spacer()
            image
        }
        .frame(height: 50)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
    
    // MARK: - Private
    
    private var countryNameTitle: some View {
        Text(countryName)
            .tint(.black)
            .font(.headline)
            .fontWeight(.bold)
            .padding()
    }
    
    private var image: some View {
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
    }

}

struct CountryCard_Previews: PreviewProvider {

    static var previews: some View {
        CountryCard(countryName: "Italy", countryFlag: URL(string: "https://flagcdn.com/w320/it.png"))
    }
}
