import SwiftUI
import ComposableArchitecture

struct CityCard: View {

    // MARK: - Properties

    let store: StoreOf<SearchCityReducer>

    @ObservedObject var model: CityCardModel
    @State private var isSaved = false

    // MARK: - Body

    var body: some View {
        HStack {
            cityTitle
            Spacer()
            saveButton
        }
        .padding()
        .background(.regularMaterial)
        .cornerRadius(20)
    }

    // MARK: - Private

    private var cityTitle: some View {
        VStack(alignment: .leading) {
            Text(model.cityName)
                .font(.title3)
                .fontWeight(.bold)
            Text("\(model.cityState) \(model.cityCountry)")
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
                    viewStore.send(.saveButtonTapped(model.cityID))
                },
                label: {
                    Image(systemName: viewStore.savedCities[model.cityID] ?? false ? "star.fill" : "star")
                    .tint(.yellow)
                    .fontWeight(.bold)
                }
            )
        }
    }

}
