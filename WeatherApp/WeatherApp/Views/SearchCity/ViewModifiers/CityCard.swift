import SwiftUI
import ComposableArchitecture

struct CityCard: View {
    
    // MARK: - Properties
    
    let store: StoreOf<SearchCityReducer>

    let cityName: String
    let cityState: String
    let cityCountry: String
    let cityID: String
    
    var isSaved = false

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
        WithViewStore(store, observe: { $0 }) { viewStore in
            Button(
                action: {
                    viewStore.send(.saveButtonTapped(cityID))
                },
                label: {
                    Image(systemName: viewStore.savedCities[cityID] ?? false ? "star.fill" : "star")
                    .tint(.yellow)
                    .fontWeight(.bold)
                }
            )
        }
    }

}
