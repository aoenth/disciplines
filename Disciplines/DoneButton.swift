//
//  DoneButton.swift
//  Disciplines
//
//  Created by Kevin Peng on 2020-04-21.
//  Copyright © 2020 Monorail Apps. All rights reserved.
//

import UIKit

class DoneButton: UIButton {
  private let btnBackgroundColor = UIColor(red: 138/255, green: 220/255, blue: 49/255, alpha: 1)
  
  override func layoutSubviews() {
    super.layoutSubviews()
    backgroundColor = btnBackgroundColor
    setTitle("Done", for: .normal)
    setTitleColor(.white, for: .normal)
    layer.cornerRadius = 8
    titleLabel?.font = .systemFont(ofSize: 18)
  }
}
