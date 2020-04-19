//
//  DisciplineButton.swift
//  Disciplines
//
//  Created by Kevin Peng on 2020-04-19.
//  Copyright © 2020 Monorail Apps. All rights reserved.
//

import UIKit

class DisciplineButton: UIButton {
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
    titleLabel?.textAlignment = .center
    layer.cornerRadius = 5
    updateButtonColors()
  }
  
  private func updateButtonColors() {
    if isCompleted {
      setTitleColor(UIColor.white.withAlphaComponent(0.2), for: .normal)
      backgroundColor = .clear
    } else {
      setTitleColor(.white, for: .normal)
      backgroundColor = UIColor.systemBlue.withAlphaComponent(0.5)
    }
  }
}
