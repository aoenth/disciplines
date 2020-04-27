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
  
  private lazy var tableView: UITableView = {
    let tv = UITableView()
    tv.register(ArchiveCell.self, forCellReuseIdentifier: cellId)
    tv.translatesAutoresizingMaskIntoConstraints = false
    tv.backgroundColor = .white
    tv.allowsSelection = false
    tv.separatorStyle = .none
    tv.dataSource = self
    tv.delegate = self
    return tv
  }()
  
  override func viewDidLoad() {
    setupBackground()
    setupNavigationBar()
    layoutViews()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    disciplines = DataManager.shared.getAllDisciplines().sorted()
    tableView.reloadData()
  }
  
  private func setupBackground() {
    view.backgroundColor = .white
  }
  
  private func setupNavigationBar() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show Main", style: .plain, target: self, action: #selector(showMainController))
  }
  
  private func layoutViews() {
    view.addSubview(tableView)
    let salg = view.safeAreaLayoutGuide
    tableView.leadingAnchor.constraint(equalToSystemSpacingAfter: salg.leadingAnchor, multiplier: 1).activate()
    tableView.topAnchor.constraint(equalToSystemSpacingBelow: salg.topAnchor, multiplier: 0).activate()
    salg.trailingAnchor.constraint(equalToSystemSpacingAfter: tableView.trailingAnchor, multiplier: 1).activate()
    salg.bottomAnchor.constraint(equalToSystemSpacingBelow: tableView.bottomAnchor, multiplier: 1).activate()
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
    let count = "\(discipline.completions.count)"
    cell.configure(name: name, date: date, count: count)
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
}
