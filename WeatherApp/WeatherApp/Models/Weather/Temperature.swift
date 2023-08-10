import Foundation

struct Temperature: Decodable, Equatable, EntityComparable {
    
    typealias Entity = TempEntity
    
    let min, max: Double
    
    init(_ model: TempEntity?) {
        self.min = model?.min ?? 0
        self.max = model?.max ?? 0
    }
    
    func saveAsEntity(_ dataController: CoreDataController) -> TempEntity {
        let tempEntity = TempEntity(context: dataController.context)
        tempEntity.id = UUID()
        tempEntity.min = min
        tempEntity.max = max
        return tempEntity
    }
}
