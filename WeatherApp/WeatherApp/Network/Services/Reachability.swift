import Foundation
import SystemConfiguration
import Network

class NetworkReachability {
    
    // MARK: - Properties
    
    private var pathMonitor: NWPathMonitor?
    private var path: NWPath?
    lazy var pathUpdateHandler: ((NWPath) -> Void) = { path in
        self.path = path
        if path.status == NWPath.Status.satisfied {
            print("Connected")
        } else if path.status == NWPath.Status.unsatisfied {
            print("unsatisfied")
        } else if path.status == NWPath.Status.requiresConnection {
            print("requiresConnection")
        }
    }
    
    private let backgroudQueue = DispatchQueue.global(qos: .background)
    
    init() {
        pathMonitor = NWPathMonitor()
        pathMonitor?.pathUpdateHandler = self.pathUpdateHandler
        pathMonitor?.start(queue: backgroudQueue)
    }
    
    // MARK: - Public
    
    func isNetworkAvailable() -> Bool {
        if let path = self.path {
            if path.status == NWPath.Status.satisfied {
                return true
            }
        }
        return false
    }
}
