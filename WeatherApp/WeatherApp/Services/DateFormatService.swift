import Foundation

class DateFormatService {
    
    static let dateFormatter = DateFormatter()
    
    static func timeFromDate(_ dateInterval: Double) -> String {
        let date = Date(timeIntervalSince1970: dateInterval)
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }
    
    static func shortDate(_ dateInterval: Double) -> String {
        let date = Date(timeIntervalSince1970: dateInterval)
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }
}
