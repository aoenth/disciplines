//
//  DisciplineButton.swift
//  Disciplines
//
//  Created by Kevin Peng on 2020-04-19.
//  Copyright © 2020 Monorail Apps. All rights reserved.
//

import UIKit

class DisciplineButton: UIButton {
  private let cellBackgroundColor = UIColor(red: 0xD8/0xFF, green: 0xD8/0xFF, blue: 0xD8/0xFF, alpha: 1)
  private let cellBorderColor = UIColor(red: 0x97/0xFF, green: 0x97/0xFF, blue: 0x97/0xFF, alpha: 1)
  private let cellFontColor = UIColor(red: 0x95/0xFF, green: 0x95/0xFF, blue: 0x95/0xFF, alpha: 1)
  
  
  var isCompleted: Bool = false {
    didSet {
      updateButtonColors()
    }
  }
  
  var disciplineDescription: String!
  
  convenience init(disciplineDescription: String) {
    self.init()
    self.disciplineDescription = disciplineDescription
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setTitle(disciplineDescription, for: .normal)
    titleLabel?.numberOfLines = 0
    titleLabel?.font = UIFont.systemFont(ofSize: 36)
    titleLabel?.adjustsFontSizeToFitWidth = true
    titleLabel?.textAlignment = .center
    layer.cornerRadius = 8
    updateButtonColors()
  }
  
  private func updateButtonColors() {
    layer.borderColor = cellBorderColor.cgColor
    layer.borderWidth = 1
    if isCompleted {
      setTitleColor(cellFontColor.withAlphaComponent(0.5), for: .normal)
      backgroundColor = .clear
    } else {
      setTitleColor(cellFontColor, for: .normal)
      backgroundColor = cellBackgroundColor
    }
  }
}
