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
      let date = Date() - TimeInterval(i * 86400)
      let startOfDay = Calendar.current.startOfDay(for: date)
      dates.append(startOfDay)
    }
    return dates
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
