import SwiftUI

struct TransparentBlurView: UIViewRepresentable {

    typealias UIViewType = UIVisualEffectView
    
    var removeFilters = false
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        DispatchQueue.main.async {
            if let backdropLayer = uiView.layer.sublayers?.first {
                if removeFilters {
                    backdropLayer.filters = []
                } else {
                    backdropLayer.filters?.removeAll(where: { String(describing: $0) != "gaussianBlur" })
                }
            }
        }
    }
}
