//
//  ReportController.swift
//  Disciplines
//
//  Created by Kevin Peng on 2020-04-23.
//  Copyright © 2020 Monorail Apps. All rights reserved.
//

import UIKit
//#if DEBUG
//class TestDiscipline {
//
//  var dateIntroduced: Date
//  var shortText: String
//  init(_ text: String, dayBeforeIntroduced: Int) {
//    self.shortText = text
//    let date = Date() - TimeInterval(dayBeforeIntroduced * 86400)
//    self.dateIntroduced = Calendar.current.startOfDay(for: date)
//  }
//}
//
//class TestCompletion {
//  var completionDate: Date = Date()
//  var discipline: TestDiscipline
//  init(daysBefore: Int, discipline: TestDiscipline) {
//    self.completionDate = Date() - TimeInterval(daysBefore * 86400)
//    self.discipline = discipline
//  }
//}
//
//let disciplines = [
//  TestDiscipline("A", dayBeforeIntroduced: 6),
//  TestDiscipline("B", dayBeforeIntroduced: 5),
//  TestDiscipline("C", dayBeforeIntroduced: 3),
//  TestDiscipline("D", dayBeforeIntroduced: 0)
//]
//#endif
class GraphController: UIViewController {
  
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
    sv.spacing = 10
    return sv
  }()
  
  private lazy var yAxisLabels: [UILabel] = {
    ["50%", "100%"].map {
      let lbl = UILabel()
      lbl.translatesAutoresizingMaskIntoConstraints = false
      lbl.text = $0
      lbl.textAlignment = .center
      lbl.font = UIFont.systemFont(ofSize: 12)
      return lbl
    }
  }()
  
  private lazy var xAxisLabels: [UILabel] = {
    let acronyms = Date.lastNDays(7).reversed()
    return acronyms.map { (acronym) -> UILabel in
      let lbl = UILabel()
      lbl.text = acronym.dayOfWeekAcronym
      lbl.font = UIFont.systemFont(ofSize: 12)
      lbl.textAlignment = .center
      return lbl
    }
  }()
  
  private lazy var xAxisStackView: UIStackView = {
    let xAxisStackView = UIStackView()
    xAxisStackView.axis = .horizontal
    xAxisStackView.translatesAutoresizingMaskIntoConstraints = false
    xAxisStackView.distribution = .fillEqually
    xAxisStackView.spacing = 10
    return xAxisStackView
  }()
  
  override func viewDidLoad() {
    view.setBackground()
    setupNavigationBar()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    fetchData()
    bars.arrangedSubviews.forEach {
      bars.removeArrangedSubview($0)
      $0.removeFromSuperview()
    }
    layoutViews()
  }
  
  func fetchData() {
    let completions = DataManager.shared.loadCompletions(daysBefore: 7, showArchived: false)
    crunchData(completions: completions)
  }
  
  private func crunchData(completions: [Completion]) {
//    #if DEBUG
//    let completions = [
//      TestCompletion(daysBefore: 6, discipline: disciplines[0]),
//      TestCompletion(daysBefore: 5, discipline: disciplines[1]),
//      TestCompletion(daysBefore: 4, discipline: disciplines[2]),
//      TestCompletion(daysBefore: 3, discipline: disciplines[1]),
//      TestCompletion(daysBefore: 3, discipline: disciplines[2]),
//      TestCompletion(daysBefore: 3, discipline: disciplines[3]),
//      TestCompletion(daysBefore: 2, discipline: disciplines[0]),
//      TestCompletion(daysBefore: 2, discipline: disciplines[1]),
//      TestCompletion(daysBefore: 2, discipline: disciplines[2]),
//      TestCompletion(daysBefore: 1, discipline: disciplines[0]),
//      TestCompletion(daysBefore: 1, discipline: disciplines[1]),
//      TestCompletion(daysBefore: 1, discipline: disciplines[2]),
//      TestCompletion(daysBefore: 0, discipline: disciplines[0]),
//      TestCompletion(daysBefore: 0, discipline: disciplines[1]),
//      TestCompletion(daysBefore: 0, discipline: disciplines[2]),
//    ]
//    #else
    let disciplines = DataManager.shared.getActiveDisciplines()
//    #endif
    
    var days = [Date: Int]()
    for completion in completions {
      let startOfDay = Calendar.current.startOfDay(for: completion.completionDate)
      days[startOfDay, default: 0] += 1
    }
    
    let lastSevenDays = Date.lastNDays(7)
    
    viewData.removeAll(keepingCapacity: true)
    for d in lastSevenDays.reversed() {
      var total = 0
      for discipline in disciplines {
        let dateIntroduced = Calendar.current.startOfDay(for: discipline.dateIntroduced)
        if d >= dateIntroduced {
          total += 1
        }
      }
      let completions = days[d] ?? 0
      if total == 0 {
        viewData.append(0)
      } else {
        viewData.append(Double(completions) / Double(total))
      }
    }
  }
  
  private func layoutViews() {
    view.addSubview(axis)
    let salg = view.safeAreaLayoutGuide
    axis.centerYAnchor.constraint(equalTo: view.centerYAnchor).activate()
    axis.leftAnchor.constraint(equalToSystemSpacingAfter: salg.leftAnchor, multiplier: 8).activate()
    salg.rightAnchor.constraint(equalToSystemSpacingAfter: axis.rightAnchor, multiplier: 6).activate()
    axis.heightAnchor.constraint(equalToConstant: 160).activate()
    
    view.addSubview(bars)
    bars.topAnchor.constraint(equalTo: axis.topAnchor).activate()
    bars.leftAnchor.constraint(equalToSystemSpacingAfter: axis.leftAnchor, multiplier: 1).activate()
    axis.rightAnchor.constraint(equalToSystemSpacingAfter: bars.rightAnchor, multiplier: 1).activate()
    bars.bottomAnchor.constraint(equalTo: axis.bottomAnchor).activate()
    
    for data in viewData {
      let barView = BarView(percent: data)
      bars.addArrangedSubview(barView)
    }
    
    view.addSubview(xAxisStackView)
    xAxisStackView.topAnchor.constraint(equalToSystemSpacingBelow: axis.bottomAnchor, multiplier: 1).activate()
    xAxisStackView.leftAnchor.constraint(equalToSystemSpacingAfter: axis.leftAnchor, multiplier: 1).activate()
    axis.rightAnchor.constraint(equalToSystemSpacingAfter: xAxisStackView.rightAnchor, multiplier: 1).activate()
    xAxisStackView.heightAnchor.constraint(equalToConstant: 30).activate()

    for dayOfWeekLabel in xAxisLabels {
      xAxisStackView.addArrangedSubview(dayOfWeekLabel)
    }
    if let lastView = xAxisStackView.arrangedSubviews.last as? UILabel {
      lastView.font = .boldSystemFont(ofSize: 12)
      
      lastView.textColor = .white
      if #available(iOS 13, *) {
        lastView.addBackground(#imageLiteral(resourceName: "Date Pointing Box"), tint: .link)
      } else {
        lastView.addBackground(#imageLiteral(resourceName: "Date Pointing Box"), tint: .systemBlue)
      }
      
    }
    
    let fullCompletionLabel = yAxisLabels[1]
    view.addSubview(fullCompletionLabel)
    fullCompletionLabel.centerYAnchor.constraint(equalTo: axis.topAnchor).activate()
    axis.leftAnchor.constraint(equalToSystemSpacingAfter: fullCompletionLabel.rightAnchor, multiplier: 1).activate()

    let halfCompletionLabel = yAxisLabels[0]
    view.addSubview(halfCompletionLabel)
    halfCompletionLabel.centerYAnchor.constraint(equalTo: axis.centerYAnchor).activate()
    axis.leftAnchor.constraint(equalToSystemSpacingAfter: halfCompletionLabel.rightAnchor, multiplier: 1).activate()
  }
  
  private func setupNavigationBar() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show Main", style: .plain, target: self, action: #selector(showMainController))
  }
  
  @objc private func showMainController() {
    navigationController?.pushViewController(ViewController(), animated: true)
  }
}
