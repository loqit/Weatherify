import Foundation

protocol EntityComparable {
    
    associatedtype Entity
    
    func saveAsEntity(_ dataController: CoreDataController) -> Entity
}
