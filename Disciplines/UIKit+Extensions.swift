//
//  UIKit+Extensions.swift
//  Disciplines
//
//  Created by Kevin Peng on 2020-04-19.
//  Copyright © 2020 Monorail Apps. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
  func activate() {
    isActive = true
  }
}

extension UIColor {
  convenience init(hex: Int) {
    let red = CGFloat((hex & 0xFF0000) >> (0x10 / 4 * 4))/0xFF
    let green = CGFloat((hex & 0x00FF00) >> (0x10 / 4 * 2))/0xFF
    let blue = CGFloat(hex & 0x0000FF)/0xFF
    self.init(red: red, green: green, blue: blue, alpha: 1)
  }
}
