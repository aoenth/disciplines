//
//  MainViewController.swift
//  Disciplines
//
//  Created by Kevin Peng on 2020-04-19.
//  Copyright © 2020 Monorail Apps. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
  private let dataSource = MainTableViewDataSource()
  private let delegate = MainTableViewDelegate()
  
  private lazy var tableView: UITableView = {
    let tv = UITableView()
    tv.translatesAutoresizingMaskIntoConstraints = false
    tv.register(DisciplineCell.self, forCellReuseIdentifier: DisciplineCell.cellId)
    tv.dataSource = dataSource
    tv.delegate = delegate
    tv.separatorStyle = .none
    
    return tv
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayout()
  }
  
  func setupLayout() {
    view.addSubview(tableView)
    let salg = view.safeAreaLayoutGuide
    tableView.topAnchor.constraint(equalToSystemSpacingBelow: salg.topAnchor, multiplier: 2).activate()
    tableView.leadingAnchor.constraint(equalToSystemSpacingAfter: salg.leadingAnchor, multiplier: 2).activate()
    salg.trailingAnchor.constraint(equalToSystemSpacingAfter: tableView.trailingAnchor, multiplier: 2).activate()
    salg.bottomAnchor.constraint(equalToSystemSpacingBelow: tableView.bottomAnchor, multiplier: 2).activate()
    
  }
}

