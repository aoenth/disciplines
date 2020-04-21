//
//  MainTableViewDelegate.swift
//  Disciplines
//
//  Created by Kevin Peng on 2020-04-19.
//  Copyright © 2020 Monorail Apps. All rights reserved.
//

import UIKit

class MainTableViewDelegate: NSObject, UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    // four paddings that are of width = 2x system spacing (2x8)
    let numberOfSections = CGFloat(tableView.numberOfSections)
    return (tableView.frame.height - 16 * (numberOfSections + 1)) / numberOfSections
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView()
    headerView.backgroundColor = .clear
    return headerView
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    16
  }
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let doneAction = UIContextualAction(style: .normal, title: "Done") { (action, sourceView, completionHandler) in
      print("index path of delete: \(indexPath)")
      completionHandler(true)
    }
    let cell = tableView.cellForRow(at: indexPath)!
    doneAction.image = createImage(rowHeight: cell.bounds.height)
    let swipeConfig = UISwipeActionsConfiguration(actions: [doneAction])
    return swipeConfig
  }
  
  func createImage(rowHeight: CGFloat) -> UIImage {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: rowHeight, height: rowHeight))
    
    let img = renderer.image { ctx in
      let c = ctx.cgContext
      let rect = CGRect(x: 0, y: 0, width: rowHeight, height: rowHeight).insetBy(dx: 8, dy: 8)
      c.setFillColor(UIColor(hex: 0x6DD400).cgColor)
      c.addEllipse(in: rect)
    }
    return img
  }
}
