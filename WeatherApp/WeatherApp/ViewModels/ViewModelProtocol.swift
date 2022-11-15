import Foundation

protocol ViewModelProtocol: ObservableObject {
  func load() async
}
