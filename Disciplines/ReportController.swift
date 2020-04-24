//
//  ReportController.swift
//  Disciplines
//
//  Created by Kevin Peng on 2020-04-23.
//  Copyright © 2020 Monorail Apps. All rights reserved.
//

import UIKit

class ReportController: UIViewController {
  
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
  
  override func viewDidLoad() {
    view.backgroundColor = .white
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
    let completions = DataManager.shared.loadCompletions(daysBefore: 7)
    crunchData(completions: completions)
  }
  
  private func crunchData(completions: [Completion]) {
    let disciplines = DataManager.shared.getAllDisciplines()
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
    
    view.insertSubview(bars, belowSubview: axis)
    bars.topAnchor.constraint(equalTo: axis.topAnchor).activate()
    bars.leftAnchor.constraint(equalToSystemSpacingAfter: axis.leftAnchor, multiplier: 1).activate()
    axis.rightAnchor.constraint(equalToSystemSpacingAfter: bars.rightAnchor, multiplier: 1).activate()
    bars.bottomAnchor.constraint(equalTo: axis.bottomAnchor).activate()
    
    for data in viewData {
      let barView = BarView(percent: data)
      bars.addArrangedSubview(barView)
    }
  }
  
  private func setupNavigationBar() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show Main", style: .plain, target: self, action: #selector(showMainController))
  }
  
  @objc private func showMainController() {
    navigationController?.pushViewController(ViewController(), animated: true)
  }
}
