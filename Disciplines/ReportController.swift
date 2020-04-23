//
//  ReportController.swift
//  Disciplines
//
//  Created by Kevin Peng on 2020-04-23.
//  Copyright © 2020 Monorail Apps. All rights reserved.
//

import UIKit

class TestDiscipline {
  
  var dateIntroduced: Date
  var shortText: String
  init(_ text: String, dayBeforeIntroduced: Int) {
    self.shortText = text
    let date = Date() - TimeInterval(dayBeforeIntroduced * 86400)
    self.dateIntroduced = Calendar.current.startOfDay(for: date)
  }
}

class TestCompletion {
  var completionDate: Date = Date()
  var discipline: TestDiscipline
  init(daysBefore: Int, discipline: TestDiscipline) {
    self.completionDate = Date() - TimeInterval(daysBefore * 86400)
    self.discipline = discipline
  }
}

class ReportController: UIViewController {
  let disciplines = [
    TestDiscipline("SomeText1", dayBeforeIntroduced: 10),
    TestDiscipline("SomeText2", dayBeforeIntroduced: 2),
    TestDiscipline("SomeText3", dayBeforeIntroduced: 3),
    TestDiscipline("SomeText4", dayBeforeIntroduced: 4)
  ]
  
  var viewData: [Double] = []
  
  private lazy var axis: AxisView = {
    let v = AxisView()
    v.translatesAutoresizingMaskIntoConstraints = false
    return v
  }()
  
  private lazy var bars: UIStackView = {
    let sv = UIStackView()
    sv.translatesAutoresizingMaskIntoConstraints = false
    sv.axis = .horizontal
    sv.distribution = .fillEqually
    sv.spacing = 5
    return sv
  }()
  
  override func viewDidLoad() {
    view.backgroundColor = .white
    crunchData()
    layoutViews()
  }
  
  private func crunchData() {
    let completions = [
      TestCompletion(daysBefore: 0, discipline: disciplines[0]),
      TestCompletion(daysBefore: 1, discipline: disciplines[1]),
      TestCompletion(daysBefore: 2, discipline: disciplines[2]),
      TestCompletion(daysBefore: 1, discipline: disciplines[3]),
      TestCompletion(daysBefore: 4, discipline: disciplines[0]),
      TestCompletion(daysBefore: 5, discipline: disciplines[1]),
      TestCompletion(daysBefore: 4, discipline: disciplines[2]),
      TestCompletion(daysBefore: 3, discipline: disciplines[3]),
      TestCompletion(daysBefore: 6, discipline: disciplines[0]),
      TestCompletion(daysBefore: 7, discipline: disciplines[1])
    ]
    var days = [Date: Int]()
    for completion in completions {
      let startOfDay = Calendar.current.startOfDay(for: completion.completionDate)
      days[startOfDay, default: 0] += 1
    }
    
    let lastSevenDays: [Date] = {
      var dates = [Date]()
      for i in 0 ... 6 {
        let date = Date() - TimeInterval(i * 86400)
        let startOfDay = Calendar.current.startOfDay(for: date)
        dates.append(startOfDay)
      }
      return dates
    }()
    
    for d in lastSevenDays.reversed() {
      var total = 0
      for discipline in disciplines {
        if d >= discipline.dateIntroduced {
          total += 1
        }
      }
      let completions = days[d] ?? 0
      viewData.append(Double(completions) / Double(total))
    }
  }
  
  private func layoutViews() {
    view.addSubview(axis)
    let salg = view.safeAreaLayoutGuide
    axis.centerYAnchor.constraint(equalTo: view.centerYAnchor).activate()
    axis.leftAnchor.constraint(equalToSystemSpacingAfter: salg.leftAnchor, multiplier: 6).activate()
    salg.rightAnchor.constraint(equalToSystemSpacingAfter: axis.rightAnchor, multiplier: 4).activate()
    axis.heightAnchor.constraint(equalToConstant: 160).activate()
    
    view.insertSubview(bars, belowSubview: axis)
    bars.topAnchor.constraint(equalTo: axis.topAnchor).activate()
    bars.leftAnchor.constraint(equalTo: axis.leftAnchor, constant: 8).activate()
    bars.rightAnchor.constraint(equalTo: axis.rightAnchor, constant: -8).activate()
    bars.bottomAnchor.constraint(equalTo: axis.bottomAnchor).activate()
    
    for data in viewData {
      let barView = BarView(percent: data)
      bars.addArrangedSubview(barView)
    }
  }
}
