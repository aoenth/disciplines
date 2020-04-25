//
//  ArchiveController.swift
//  Disciplines
//
//  Created by Kevin Peng on 2020-04-24.
//  Copyright © 2020 Monorail Apps. All rights reserved.
//

import UIKit

class ArchiveController: UITableViewController {
  let cellId = "cellId"
  var disciplines = [Discipline]()
  
  override func viewDidLoad() {
    setupNavigationBar()
    disciplines.append(contentsOf: DataManager.shared.getAllDisciplines())
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    tableView.reloadData()
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId)!
    let discipline = disciplines[indexPath.row]
    cell.textLabel?.text = discipline.shortText + String(discipline.completions.count)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return disciplines.count
  }
  
  private func setupNavigationBar() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show Main", style: .plain, target: self, action: #selector(showMainController))
  }
  
  @objc private func showMainController() {
    navigationController?.pushViewController(ViewController(), animated: true)
  }
}
