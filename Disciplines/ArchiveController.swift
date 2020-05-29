//
//  ArchiveController.swift
//  Disciplines
//
//  Created by Kevin Peng on 2020-04-24.
//  Copyright © 2020 Monorail Apps. All rights reserved.
//

import UIKit

class ArchiveController: UIViewController {
  let cellId = "cellId"
  var disciplines = [Discipline]()
  var disciplineRankings = [Discipline: Int]()
  
  private var _tableView: UITableView?
  private var tableView: UITableView {
    if let tableView = _tableView {
      return tableView
    }
    
    let tv = UITableView()
    tv.register(ArchiveCell.self, forCellReuseIdentifier: cellId)
    tv.translatesAutoresizingMaskIntoConstraints = false
    tv.setBackground()
    tv.allowsSelection = false
    tv.separatorStyle = .none
    tv.dataSource = self
    tv.delegate = self
    _tableView = tv
    return tv
  }
  
  private lazy var backdrop: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.textColor = .systemGray
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override func viewDidLoad() {
    setupBackground()
    layoutViews()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    disciplines = DataManager.shared.getAchievementWorthyDisciplines().sorted()

    calculateRankings()
    
    refreshViews()
    
  }
  
  fileprivate func calculateRankings() {
    var ranking = 1
    for (i, d) in disciplines.enumerated() {
      disciplineRankings[d] = ranking
      if i + 1 < disciplines.count {
        let nextDiscipline = disciplines[i + 1]
        let nextCount = nextDiscipline.completions.count
        let thisCount = d.completions.count
        if nextCount < thisCount {
          ranking += 1
        }
      }
    }
  }
  
  fileprivate func refreshViews() {
    if disciplines.count > 0 {
      removeBackdrop()
      if _tableView == nil {
        layoutTableView()
      } else {
        tableView.isHidden = false
        tableView.reloadData()
      }
    } else {
      if _tableView != nil {
        tableView.isHidden = true
      }
      if view.subviews.contains(backdrop) == false {
        displayBackdrop("Nothing to Show")
      }
    }
  }
  
  private func setupBackground() {
    view.setBackground()
  }
  
  private func layoutViews() {
    if disciplines.count > 0 {
      layoutTableView()
    }
  }
  
  fileprivate func layoutTableView() {
    view.addSubview(tableView)
    let salg = view.safeAreaLayoutGuide
    tableView.leadingAnchor.constraint(equalToSystemSpacingAfter: salg.leadingAnchor, multiplier: 2).activate()
    tableView.topAnchor.constraint(equalToSystemSpacingBelow: salg.topAnchor, multiplier: 0).activate()
    salg.trailingAnchor.constraint(equalToSystemSpacingAfter: tableView.trailingAnchor, multiplier: 2).activate()
    salg.bottomAnchor.constraint(equalToSystemSpacingBelow: tableView.bottomAnchor, multiplier: 1).activate()
  }
  
  fileprivate func removeBackdrop() {
    if view.subviews.contains(backdrop) {
      backdrop.removeFromSuperview()
    }
  }
  
  fileprivate func displayBackdrop(_ message: String) {
    backdrop.text = message
    view.addSubview(backdrop)
    let salg = view.safeAreaLayoutGuide
    backdrop.leadingAnchor.constraint(equalToSystemSpacingAfter: salg.leadingAnchor, multiplier: 2).activate()
    backdrop.topAnchor.constraint(equalToSystemSpacingBelow: salg.topAnchor, multiplier: 0).activate()
    salg.trailingAnchor.constraint(equalToSystemSpacingAfter: backdrop.trailingAnchor, multiplier: 2).activate()
    salg.bottomAnchor.constraint(equalToSystemSpacingBelow: backdrop.bottomAnchor, multiplier: 1).activate()
  }
  
  @objc private func showMainController() {
    navigationController?.pushViewController(ViewController(), animated: true)
  }
}

extension ArchiveController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! ArchiveCell
    let discipline = disciplines[indexPath.section]
    let name = discipline.shortText
    let date = discipline.dateIntroduced.archiveDateFormat
    let count = discipline.completions.count
    cell.configure(name: name, date: date, count: String(count))
    if count == 0 {
      cell.backgroundColor = .systemOrange
    } else {
      let rank = disciplineRankings[discipline, default: 1]
      cell.backgroundColor = UIColor.colorForRank(at: rank, outOf: disciplineRankings.count)
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    disciplines.count
  }
}

extension ArchiveController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    110
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let v = UIView()
    v.backgroundColor = .clear
    return v
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    10
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let disciplineToDelete = self.disciplines[indexPath.section]
      disciplines.remove(at: indexPath.section)
      DataManager.shared.delete(discipline: disciplineToDelete)
      DataManager.shared.saveContext()
      let indexSet = IndexSet([indexPath.section])
      tableView.deleteSections(indexSet, with: .automatic)
      refreshViews()
    }
  }
}
