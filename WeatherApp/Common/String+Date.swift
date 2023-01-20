//
//  String+Date.swift
//  WeatherApp
//
//  Created by CBRE on 19/01/23.
//

import Foundation

private let longDateFormat = "EEEE, dd MMM yyyy"
private let dayFormat = "EEEE"

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
}
