import Foundation

struct Temperature: Decodable {
  let min, max: Double
  
  init(_ model: TempEntity?) {
    self.min = model?.min ?? 0
    self.max = model?.max ?? 0
  }
  
  func saveAsEntity(_ dataController: DataController) -> TempEntity {
    let tempEntity = TempEntity(context: dataController.context)
    tempEntity.min = self.min
    tempEntity.max = self.max
    return tempEntity
  }
}
