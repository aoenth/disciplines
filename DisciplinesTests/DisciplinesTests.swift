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
    dataManager.removeSavedDisciplines()
    dataManager.removeSavedCompletions()
  }
  
  func prepareDataManager() -> [Discipline] {
    let initial = ["Sleep at 9:30PM",
                   "Wake up at 4:30AM",
                   "Learn from any online resource whenever bored",
                   "Max 1 Overwatch game a day",
                   "Max 1 hour of music listening a day"]
    
    let fixedDate = Date(timeIntervalSince1970: 1587677869)
    let customCreationDates = [
      fixedDate - TimeInterval(1 * 86400),
      fixedDate - TimeInterval(0 * 86400),
      fixedDate - TimeInterval(3 * 86400),
      fixedDate - TimeInterval(3 * 86400),
      fixedDate - TimeInterval(2 * 86400)
    ]
    
    var disciplines = [Discipline]()
    for i in 0 ..< initial.count {
      let discipline = dataManager.create(initial[i], customCreationDate: customCreationDates[i])
      disciplines.append(discipline)
    }
      
    return disciplines
  }
  
  func testPrepareDataManager() {
    let result = prepareDataManager()
    XCTAssertEqual(result.count, 5)
  }
  
  func testAddDateIntroduced() {
    let fixedDate = Date(timeIntervalSince1970: 1587677869)
    let customCreationDates = [
      fixedDate - TimeInterval(1 * 86400),
      fixedDate - TimeInterval(0 * 86400),
      fixedDate - TimeInterval(3 * 86400),
      fixedDate - TimeInterval(3 * 86400),
      fixedDate - TimeInterval(2 * 86400)
    ]
    
    let disciplines = prepareDataManager()
    let dates = disciplines.map { $0.dateIntroduced }
    XCTAssertEqual(customCreationDates, dates)
  }
  
  func testDataManagerCompletionFetching() {
    let fixedDate = Date(timeIntervalSince1970: 1587677869)
    let completionDates = [
      fixedDate - TimeInterval(2 * 86400),
      fixedDate - TimeInterval(1 * 86400),
      fixedDate - TimeInterval(4 * 86400),
      fixedDate - TimeInterval(4 * 86400),
      fixedDate - TimeInterval(0 * 86400)
    ]
    let disciplines = prepareDataManager()
    for i in 0 ..< 5 {
      dataManager.complete(discipline: disciplines[i],
                           customCompletion: completionDates[i], onComplete: nil)
    }
    let completions = dataManager.loadCompletions(daysBefore: 7)
    XCTAssertEqual(completionDates.sorted(), completions.map { $0.completionDate })
  }
  
  func testEmptyStartingState() {
    XCTAssertEqual(dataManager.getAllCompletions(), [Completion]())
    XCTAssertEqual(dataManager.getAllDisciplines(), [Discipline]())
  }
  
  func testCompletingDisciplinesWillGraphData() {
    _ = prepareDataManager()
    let sut = GraphController()
    sut.fetchData()
    let viewData = sut.viewData
    
    XCTAssertEqual(viewData, [1,  0.5,  0.5,  1,  1,  1,  0.75])
  }
}
