//
//  DisciplineCell.swift
//  Disciplines
//
//  Created by Kevin Peng on 2020-04-19.
//  Copyright © 2020 Monorail Apps. All rights reserved.
//

import UIKit


class DisciplineCell: UITableViewCell {
  private let cellBackgroundColor = UIColor(red: 0xD8/0xFF, green: 0xD8/0xFF, blue: 0xD8/0xFF, alpha: 1)
  private let cellBorderColor = UIColor(red: 0x97/0xFF, green: 0x97/0xFF, blue: 0x97/0xFF, alpha: 1)
  private let cellFontColor = UIColor(red: 0x95/0xFF, green: 0x95/0xFF, blue: 0x95/0xFF, alpha: 1)
  static let cellId = "disciplineCell"
  
  private lazy var disciplineDescription: UILabel = {
    let lbl = UILabel()
    lbl.translatesAutoresizingMaskIntoConstraints = false
    lbl.font = UIFont.systemFont(ofSize: 48)
    lbl.textColor = cellFontColor
    lbl.textAlignment = .center
    lbl.numberOfLines = 0
    return lbl
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    applyCellStyle()
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    applyCellStyle()
    setupLayout()
  }
  
  func applyCellStyle() {
    layer.cornerRadius = 8
    backgroundColor = cellBackgroundColor
    layer.borderColor = cellBorderColor.cgColor
    layer.borderWidth = 1
  }
  
  func setupLayout() {
    
  }
  
  
}
