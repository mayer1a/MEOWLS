//
//  Date+Formatter.swift
//  MEOWLS
//
//  Created by Artem Mayer on 02.10.2024.
//

import Foundation

public extension Date {

    var toStandartString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        return dateFormatter.string(from: self)
    }

    var toDeliveryString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"

        return dateFormatter.string(from: self)
    }

    var isThisYear: Bool {
        Calendar.current.component(.year, from: self) == Calendar.current.component(.year, from: Date())
    }

    var briefYearDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = isThisYear ? "d MMMM" : "d MMMM yyyy"

        return dateFormatter.string(from: self)
    }

    var birthDate: String {
        Date.birthDateFormatter.string(from: self)
    }

    var toClearISO8601: String {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        let midnightDate = calendar.startOfDay(for: self)

        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.timeZone = TimeZone(abbreviation: "UTC")!
        isoFormatter.formatOptions = [.withInternetDateTime]

        return isoFormatter.string(from: midnightDate)
    }

    static let birthDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"

        return dateFormatter
    }()

    func pickerRange(isTodayUpper: Bool) -> ClosedRange<Date> {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: self)
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)

        var components = DateComponents()
        components.calendar = calendar
        components.year = year - 100
        components.month = month
        components.day = day
        components.timeZone = TimeZone(secondsFromGMT: 0)
        let min = calendar.date(from: components) ?? Date()

        components.year = isTodayUpper ? year : year + 100
        let max = calendar.date(from: components)  ?? Date()

        return min...max
    }

    static func formattedSchedule(sinceDate: Date?, untilDate: Date?) -> String? {
        var localizedPeriod: String?

        if let sinceDate, let untilDate {
            let fromTo = Strings.Promotion.fromto
            localizedPeriod = String(format: fromTo, sinceDate.briefYearDate, untilDate.briefYearDate)
        } else if let sinceDate {
            localizedPeriod = String(format: Strings.Promotion.from, sinceDate.briefYearDate)
        } else if let untilDate {
            localizedPeriod = String(format: Strings.Promotion.fromto, untilDate.briefYearDate)
        } else {
            return nil
        }

        return localizedPeriod
    }

//    func toOrderString(with timeZone: TimeZone) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        dateFormatter.timeZone = timeZone
//
//        return dateFormatter.string(from: self)
//    }

}
