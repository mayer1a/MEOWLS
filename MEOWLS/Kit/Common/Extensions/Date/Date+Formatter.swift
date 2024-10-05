//
//  Date+Formatter.swift
//  MEOWLS
//
//  Created by Artem Mayer on 02.10.2024.
//

import Foundation

extension Date {

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
