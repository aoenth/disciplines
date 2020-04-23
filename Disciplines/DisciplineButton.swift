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
  
  var isCompleted: Bool {
    discipline.completion != nil
  }
  
  var discipline: Discipline!
  
  convenience init(discipline: Discipline) {
    self.init()
    self.discipline = discipline
    applyStyles()
  }
  
  private func createResizableTextLabel() {
    label.backgroundColor = cellBackgroundColor
    let safeBounds = safeAreaLayoutGuide.layoutFrame
    label.frame = safeBounds.insetBy(dx: 10, dy: 10)
    addSubview(label)
    
    let attributes: [NSAttributedString.Key: Any] = [
      .font: UIFont.systemFont(ofSize: 12),
      .foregroundColor: cellFontColor
    ]
    label.attributedText = NSAttributedString(string: discipline.shortText, attributes: attributes)
  }
  
  private func applyStyles() {
    layer.cornerRadius = 8
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    updateButtonColors()
    createResizableTextLabel()
  }
  
  private func updateButtonColors() {
    layer.borderWidth = 1
    if isCompleted {
      layer.borderColor = cellBorderCompleteColor.cgColor
      setTitleColor(cellFontColor.withAlphaComponent(0.5), for: .normal)
      backgroundColor = .clear
    } else {
      layer.borderColor = cellBorderColor.cgColor
      setTitleColor(cellFontColor, for: .normal)
      backgroundColor = cellBackgroundColor
    }
  }
}
