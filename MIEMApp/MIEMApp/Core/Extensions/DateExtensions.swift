//
//  DateExtensions.swift
//  MIEMApp
//
//  Created by Тимофей Фёдоров on 19.01.2021.
//

import Foundation

extension Date {
  var week: (Date, Date) {
    let gregorian = Calendar(identifier: .iso8601)
    guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else {
      return (.distantPast, .distantFuture)
    }
    return (
      gregorian.date(byAdding: .day, value: 1, to: sunday) ?? .distantPast,
      gregorian.date(byAdding: .day, value: 7, to: sunday) ?? .distantFuture
    )
  }
}

extension Date {
  func string(format: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.calendar = Calendar(identifier: .iso8601)
    dateFormatter.locale = Locale(identifier: "ru_RU")
    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: self)
  }
}
