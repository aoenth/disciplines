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
}
