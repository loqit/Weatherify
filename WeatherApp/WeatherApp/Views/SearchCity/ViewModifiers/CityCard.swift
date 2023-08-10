import SwiftUI

struct CityCard: View {
    
    // MARK: - Propertie

    private let coreDataService = CityCoreDataService(dataController: CoreDataController())
    let cityInfo: City

    // MARK: - Body

    var body: some View {
        HStack {
            VStack {
                Text(cityInfo.name)
                    .font(.headline)
                    .fontWeight(.bold)
                Text("\(cityInfo.state ?? "") \(cityInfo.country)")
                    .font(.caption)
                    .fontWeight(.light)
            }
            .frame(minWidth: 150)
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
