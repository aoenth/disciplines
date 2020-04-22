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
    if frame.width > 50 {
      setTitle("Done", for: .normal)
    } else {
      setTitle("", for: .normal)
    }
  }
  
  
}
