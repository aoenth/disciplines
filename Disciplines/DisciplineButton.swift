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
  private let cellBorderCompleteColor = UIColor(red: 0xBB/0xFF, green: 0xBB/0xFF, blue: 0xBB/0xFF, alpha: 1)
  private let cellFontColor = UIColor(red: 0x95/0xFF, green: 0x95/0xFF, blue: 0x95/0xFF, alpha: 1)
  private let label = AKLabel()
  
  var discipline: Discipline!
  
  convenience init(discipline: Discipline) {
    self.init()
    self.discipline = discipline
    applyStyles()
    addSubview(label)
  }
  
  private func applyStyles() {
    layer.cornerRadius = 8
    layer.borderWidth = 1
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    createResizableTextLabel()
    updateButtonColors()
  }
  
  private func createResizableTextLabel() {
    let safeBounds = safeAreaLayoutGuide.layoutFrame
    label.frame = safeBounds.insetBy(dx: 16, dy: 10)
  }
  
  private func updateButtonColors() {
    if discipline.isCompletedForToday {
      layer.borderColor = cellBorderCompleteColor.cgColor
      updateTitleFontColor(to: cellFontColor.withAlphaComponent(0.5))
      backgroundColor = .clear
    } else {
      layer.borderColor = cellBorderColor.cgColor
      updateTitleFontColor(to: cellFontColor)
      backgroundColor = cellBackgroundColor
    }
  }
  
  private func updateTitleFontColor(to color: UIColor) {
    let attributes: [NSAttributedString.Key: Any] = [
      .font: UIFont.systemFont(ofSize: 12),
      .foregroundColor: color
    ]
    label.textAlignment = .center
    label.attributedText = NSAttributedString(string: discipline.shortText, attributes: attributes)
  }
}
