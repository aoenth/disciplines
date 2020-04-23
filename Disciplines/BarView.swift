//
//  BarView.swift
//  Disciplines
//
//  Created by Kevin Peng on 2020-04-23.
//  Copyright © 2020 Monorail Apps. All rights reserved.
//

import UIKit

class BarView: UIView {
  private var percent: Double = 0
  
  convenience init(percent: Double) {
    self.init()
    applyStyles()
    self.percent = percent
  }
  
  override func draw(_ rect: CGRect) {
    let upperLeftX: CGFloat = 0
    let upperLeftY = rect.height * CGFloat(1 - percent)
    let lowerRightX = rect.width
    let lowerRightY = rect.height
    let width = lowerRightX - upperLeftX
    let height = lowerRightY - upperLeftY
    let rect = CGRect(x: upperLeftX, y: upperLeftY, width: width, height: height)
    
    let path = UIBezierPath(rect: rect)
    UIColor(hex: 0x6DD400).setFill()
    path.fill()
  }
  
  private func applyStyles() {
    backgroundColor = .clear
  }
}
