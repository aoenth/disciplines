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

extension UIView {
  func setBackground() {
    if #available(iOS 13, *) {
      backgroundColor = .systemBackground
    } else {
      backgroundColor = .gray
    }
  }
}

extension UILabel {
  func addBackground(_ image: UIImage) {
    if let superview = superview {
      let iv = UIImageView(image: image)
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
    switch percentage {
    case 0...0.5:
      return firstHalf(percentage: percentage * 2)
    case 0.5...1:
      return secondHalf(percentage: (percentage - 0.5) * 2)
    default:
      fatalError("Bad Input: rank must satisfy 0 <= rank <= 1")
    }
  }
  
  static fileprivate func firstHalf(percentage: Double) -> UIColor {
    let begin = UIColor.systemGreen.cgColor.components!
    let end = UIColor.systemYellow.cgColor.components!
    return createColor(begin: begin, end: end, percentage: percentage)
  }
  
  static fileprivate func secondHalf(percentage: Double) -> UIColor {
    let begin = UIColor.systemYellow.cgColor.components!
    let end = UIColor.systemOrange.cgColor.components!
    return createColor(begin: begin, end: end, percentage: percentage)
  }
  
  static fileprivate func createColor(begin: [CGFloat], end: [CGFloat], percentage: Double) -> UIColor {
    var colorDiff = begin
    for i in 0 ..< 3 {
      colorDiff[i] = begin[i] + (end[i] - begin[i]) * CGFloat(percentage)
    }
    return UIColor(red: colorDiff[0], green: colorDiff[1], blue: colorDiff[2], alpha: 1)
  }
}
