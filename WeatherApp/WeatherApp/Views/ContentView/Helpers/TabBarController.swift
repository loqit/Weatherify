import UIKit
import SwiftUI

struct TabBarController: UIViewControllerRepresentable {

    typealias UIViewControllerType = UITabBarController

    var navigationControllers: [UINavigationController] = []
    var content: [AnyView]

    init(content: () -> [AnyView]) {
        self.content = content()
    }

    mutating func makeUIViewController(context: Context) -> UITabBarController {
        let tab = UITabBarController.init()
        let vcs = content.map { v -> UIViewController in
            let h = UIHostingController(rootView: v)
            let n = UINavigationController(rootViewController: h)
            navigationControllers.append(n)
            n.tabBarItem = UITabBarItem(title: "A", image: UIImage(systemName: "book.circle"), selectedImage: nil)
            return n
        }
        tab.viewControllers = vcs
        return tab
    }
    
    func updateUIViewController(_ uiViewController: UITabBarController, context: Context) {}
}
