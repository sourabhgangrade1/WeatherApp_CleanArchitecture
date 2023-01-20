import Foundation

private let longDateFormat = "EEEE, dd MMM yyyy"
private let dayFormat = "EEEE"
private let shortTimeFormat = "ha"

extension DateFormatter {
    static func getLongDateFormatter() -> DateFormatter {
        let formatter  = DateFormatter()
        formatter.dateFormat = longDateFormat
        return formatter
    }

    static func getDayFormatter() -> DateFormatter {
        let formatter  = DateFormatter()
        formatter.dateFormat = dayFormat
        return formatter
    }

    static func getShortTimeFormatter() -> DateFormatter {
        let formatter  = DateFormatter()
        formatter.dateFormat = shortTimeFormat
        return formatter
    }
}

extension Date {
    func getLongDate() -> String {
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = longDateFormat
        return DateFormatter.getLongDateFormatter().string(from: self)
    }

    func getDay() -> String {
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = dayFormat
        return DateFormatter.getDayFormatter().string(from: self)
    }

    func getShortTime() -> String {
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = shortTimeFormat
        return DateFormatter.getShortTimeFormatter().string(from: self)
    }
}
