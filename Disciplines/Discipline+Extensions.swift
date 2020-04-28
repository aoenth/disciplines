//
//  Discipline+Extensions.swift
//  Disciplines
//
//  Created by Kevin Peng on 2020-04-27.
//  Copyright © 2020 Monorail Apps. All rights reserved.
//

import Foundation

extension Discipline: Comparable {
  public static func <(lhs: Discipline, rhs: Discipline) -> Bool {
    return lhs.completions.count > rhs.completions.count
  }
  
  var isCompletedForToday: Bool {
    completions.contains { (date) -> Bool in
      if let date = date as? Date {
        let storedDate = Calendar.current.startOfDay(for: date)
        let today = Calendar.current.startOfDay(for: Date())
        return storedDate == today
      } else {
        return false
      }
    }
  }
}
