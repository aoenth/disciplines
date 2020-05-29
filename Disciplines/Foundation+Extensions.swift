//
//  Foundation+Extensions.swift
//  Disciplines
//
//  Created by Kevin Peng on 2020-04-24.
//  Copyright © 2020 Monorail Apps. All rights reserved.
//

import Foundation

extension Date {
  /**
   Returns an array of  the date of the last n days, today is 0th element
   */
  static func lastNDays(_ n: Int) -> [Date] {
    var dates = [Date]()
    for i in 0 ..< n {
      dates.append(Date.nDaysBefore(i))
    }
    return dates
  }
  
  static func nDaysBefore(_ n: Int) -> Date {
    let date = Date() - TimeInterval(n * 86400)
    return Calendar.current.startOfDay(for: date)
  }
  
  var dayOfWeek: String {
    let weekDay = Calendar.current.component(.weekday, from: self)
    let dateFormatter = DateFormatter()
    return dateFormatter.weekdaySymbols[weekDay - 1]
  }
  
  var dayOfWeekAcronym: String {
    let name = self.dayOfWeek
    return String(name.first!)
  }
  
  var archiveDateFormat: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM d, yyyy"
    let dateString = dateFormatter.string(from: self)
    return dateString
  }
}
