import Foundation

class DateFormatService {

    static let dateFormatter = DateFormatter()

    static func timeFromDate(_ dateInterval: Double) -> String {
        let date = Date(timeIntervalSince1970: dateInterval)
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale.current
        if Date.now >= date {
            return "Now"
        }
        return dateFormatter.string(from: date)
    }
    
    static func shortDate(_ dateInterval: Double) -> String {
        let date = Date(timeIntervalSince1970: dateInterval)
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }
    
    static func dayOfWeek(_ dateInterval: Double) -> String {
        let date = Date(timeIntervalSince1970: dateInterval)
        dateFormatter.dateFormat = "EE"
        dateFormatter.locale = Locale.current
        if Calendar.current.isDateInToday(date) || Calendar.current.isDateInTomorrow(date) {
            dateFormatter.timeStyle = .none
            dateFormatter.dateStyle = .short
            dateFormatter.doesRelativeDateFormatting = true
            return dateFormatter.string(from: date).capitalized
        }
        return dateFormatter.string(from: date).capitalized
    }
}
