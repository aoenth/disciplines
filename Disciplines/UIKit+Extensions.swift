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
    let red = CGFloat((hex & 0xFF0000) >> (4 * 4))/0xFF
    let green = CGFloat((hex & 0x00FF00) >> (4 * 2))/0xFF
    let blue = CGFloat(hex & 0x0000FF)/0xFF
    self.init(red: red, green: green, blue: blue, alpha: 1)
  }
}

extension UIView {
  func setBackground() {
    backgroundColor = UIColor(hex: 0xD8D8D8)
  }
}

extension UILabel {
  func addBackground(_ image: UIImage, tint: UIColor? = nil) {
    if let superview = superview {
      let imageToInclude: UIImage
      let iv = UIImageView()
      
      if let tint = tint {
        imageToInclude = image.withRenderingMode(.alwaysTemplate)
        iv.tintColor = tint
      } else {
        imageToInclude = image
      }
      
      iv.image = imageToInclude
      iv.translatesAutoresizingMaskIntoConstraints = false
      iv.contentMode = .scaleAspectFit
      superview.addSubview(iv)
      iv.leadingAnchor.constraint(equalTo: leadingAnchor).activate()
      iv.trailingAnchor.constraint(equalTo: trailingAnchor).activate()
      iv.topAnchor.constraint(equalTo: topAnchor).activate()
      iv.bottomAnchor.constraint(equalTo: bottomAnchor).activate()
      superview.sendSubviewToBack(iv)
    }
  }
}

extension UIColor {
  static func colorForRank(at rank: Int, outOf total: Int) -> UIColor {
    if total <= 1 {
      return .systemGreen
    }
    
    let percentage = Double(rank - 1) / Double(total - 1)
    return colorForPercent(1 - percentage)
  }
  
  /**
    * Red: `0..<0.33`
    * Orange: `0.33..<0.66`
    * Yellow: `0.66..<1`
    * Green: `1`
   */
  static func colorForPercent(_ percentage: Double) -> UIColor {
    switch percentage {
    case 0..<0.33:
      return UIColor(hex: 0xE02020)
    case 0.33..<0.66:
      return UIColor(hex: 0xFA6400)
    case 0.66..<1:
      return UIColor(hex: 0xF7B500)
    case 1:
      return UIColor(hex: 0x6DD400)
    default:
      fatalError("Bad Input: percentage must satisfy 0 <= percentage <= 1")
    }
  }
}
