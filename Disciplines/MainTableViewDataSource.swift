//
//  MainTableViewDataSource.swift
//  Disciplines
//
//  Created by Kevin Peng on 2020-04-19.
//  Copyright © 2020 Monorail Apps. All rights reserved.
//

import UIKit

class MainTableViewDataSource: NSObject, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    1
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return DataManager.shared.numberOfItems()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: DisciplineCell.cellId, for: indexPath) as! DisciplineCell
    let discipline = DataManager.shared.discipline(at: indexPath.section)
    cell.configureCell("\(discipline.shortText)")
    return cell
  }
}
