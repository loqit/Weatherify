import SwiftUI

struct FloatedButton: View {

    // MARK: - Properties

    let title: String
    
    // MARK: - Body

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.blue)
                .frame(width: 150, height: 50)
                .shadow(radius: 25)
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
        }
    }
}

struct DrawRouteButton_Previews: PreviewProvider {

    static var previews: some View {
        FloatedButton(title: "Draw a route")
    }
}
