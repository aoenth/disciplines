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
  
  override func layoutSubviews() {
    super.layoutSubviews()
    backgroundColor = btnBackgroundColor
    setTitle("Archive", for: .normal)
    setTitleColor(.white, for: .normal)
    layer.cornerRadius = 8
    titleLabel?.font = .systemFont(ofSize: 18)
    titleLabel?.adjustsFontSizeToFitWidth = true
  }
}
