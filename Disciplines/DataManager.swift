//
//  DataManager.swift
//  Disciplines
//
//  Created by Kevin Peng on 2020-04-19.
//  Copyright © 2020 Monorail Apps. All rights reserved.
//

import Foundation

class DataManager {
  static let shared = DataManager()
  
  private init() {
    
  }
  
  public var disciplines: [String] {
    ["Sleep at 9:30PM",
     "Wake up at 4:30AM",
     "Learn from any online resource whenever bored",
     "Max 1 Overwatch game a day",
     "Max 1 hour of music listening a day"]
  }
  
}
