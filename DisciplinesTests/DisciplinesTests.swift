//
//  DisciplinesTests.swift
//  DisciplinesTests
//
//  Created by Kevin Peng on 2020-04-23.
//  Copyright © 2020 Monorail Apps. All rights reserved.
//

import XCTest
@testable import Disciplines

class DisciplinesTests: XCTestCase {
  var dataManager: DataManager!
  
  override func setUp() {
    dataManager = DataManager.shared
    dataManager.removeSavedData()
  }
  
  func prepareDataManager(_ transformation: ((Discipline) -> Discipline)?) -> [Discipline] {
    let initial = ["Sleep at 9:30PM",
                   "Wake up at 4:30AM",
                   "Learn from any online resource whenever bored",
                   "Max 1 Overwatch game a day",
                   "Max 1 hour of music listening a day"]
    var disciplines = [Discipline]()
    initial.forEach { string in
      dataManager.create(string) {
        disciplines.append($0)
      }
    }
    disciplines = disciplines.map(transformation ?? { return $0 })
    return disciplines
  }
  
  func testPrepareDataManager() {
    let result = prepareDataManager(nil)
    XCTAssertEqual(result.count, 5)
  }
  
  func testAddDateIntroduced() {
    let fixedDate = Date(timeIntervalSince1970: 1587677869)
    let lastSevenDays: [Date] = {
      var dates = [Date]()
      for i in 0 ... 6 {
        let date = fixedDate - TimeInterval(i * 86400)
        let startOfDay = Calendar.current.startOfDay(for: date)
        dates.append(startOfDay)
      }
      return dates
    }()
    var index = 0
    
    let transformation = { (d: Discipline) -> Discipline in
      d.dateIntroduced = lastSevenDays[index]
      index += 1
      return d
    }
    
    let disciplines = prepareDataManager(transformation)
    let dates = disciplines.map { $0.dateIntroduced }
    XCTAssertEqual(dates[0..<5], lastSevenDays[0..<5])
  }
}
