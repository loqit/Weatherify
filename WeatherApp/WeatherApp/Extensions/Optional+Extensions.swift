import Foundation

extension Optional {
    
    public func `do`(_ action: (Wrapped) -> Void) {
        self.map(action)
    }
    
    public func `do`(_ action: ((Wrapped) -> Void)?) {
        action.do(self.do)
    }
}
