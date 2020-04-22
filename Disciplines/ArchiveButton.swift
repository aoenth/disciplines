//
//  ArchiveButton.swift
//  Disciplines
//
//  Created by Kevin Peng on 2020-04-22.
//  Copyright © 2020 Monorail Apps. All rights reserved.
//

import UIKit

class ArchiveButton: UIButton {
  private let btnBackgroundColor = UIColor(hex: 0xFA6400)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    applyStyles()
  }
  
  func applyStyles() {
    setTitleColor(.white, for: .normal)
    layer.cornerRadius = 8
    titleLabel?.font = .preferredFont(forTextStyle: .body)
    backgroundColor = btnBackgroundColor
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    applyStyles()
  }
  
  
  override func layoutSubviews() {
    super.layoutSubviews()
    if frame.width > 70 {
      setTitle("Archive", for: .normal)
    } else {
      setTitle("", for: .normal)
    }
  }
}
