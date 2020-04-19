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
  
  var disciplines: [String] {
    fetchSaved()
  }
  
  func create(_ discipline: String, completion: (() -> Void)? = nil) {
    save(discipline)
    completion?()
  }
  
  func getAllDisciplines() -> [String] {
    fetchSaved()
  }
  
  private func save(_ discipline: String) {
    let defaults = UserDefaults.standard
    var saved = [String]()
    if let existing = defaults.array(forKey: "CURRENT_DISCIPLINES") as? [String] {
      saved = existing
    }
    saved.append(discipline)
    defaults.set(saved,  forKey: "CURRENT_DISCIPLINES")
  }
 
  private func fetchSaved() -> [String] {
    var result = [String]()
    let initial = ["Sleep at 9:30PM",
     "Wake up at 4:30AM",
     "Learn from any online resource whenever bored",
     "Max 1 Overwatch game a day",
     "Max 1 hour of music listening a day"]
    result.append(contentsOf: initial)
    
    let defaults = UserDefaults.standard
    if let saved = defaults.array(forKey: "CURRENT_DISCIPLINES") as? [String] {
      result.append(contentsOf: saved)
    }
    
    return result
  }
}
