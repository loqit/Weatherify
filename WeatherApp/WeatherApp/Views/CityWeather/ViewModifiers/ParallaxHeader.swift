import SwiftUI

struct ParallaxHeader<Content: View, Space: Hashable>: View {

    // MARK: - Properties
    
    let content: () -> Content
    let coordinateSpace: Space
    let defaultHeight: CGFloat

    // MARK: - Init

    init(coordinateSpace: Space,
         defaultHeight: CGFloat,
         @ViewBuilder _ content: @escaping () -> Content) {
        self.content = content
        self.coordinateSpace = coordinateSpace
        self.defaultHeight = defaultHeight
    }
    
    // MARK: - Body

    var body: some View {
        GeometryReader { proxy in
            let offset = offset(for: proxy)
            let heightModifier = heightModifier(for: proxy)
            let blurRadius = min(
                heightModifier / 20,
                max(10, heightModifier / 20)
            )
            content()
                .edgesIgnoringSafeArea(.horizontal)
                .frame(
                    width: proxy.size.width,
                    height: proxy.size.height + heightModifier
                )
                .offset(y: offset)
                .blur(radius: blurRadius)
        }
        .frame(height: defaultHeight)
    }

    // MARK: - Private

    private func offset(for proxy: GeometryProxy) -> CGFloat {
        let frame = proxy.frame(in: .named(coordinateSpace))
        return frame.minY < 0 ? -frame.minY * 0.8: -frame.minY
    }

    private func heightModifier(for proxy: GeometryProxy) -> CGFloat {
        let frame = proxy.frame(in: .named(coordinateSpace))
        return max(0, frame.minY)
    }
}
