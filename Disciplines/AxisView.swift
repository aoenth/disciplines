//
//  AxisView.swift
//  Disciplines
//
//  Created by Kevin Peng on 2020-04-23.
//  Copyright © 2020 Monorail Apps. All rights reserved.
//

import UIKit

@IBDesignable
class AxisView: UIView {
  override func layoutSubviews() {
    super.layoutSubviews()
    backgroundColor = .clear
  }
  
  private let lineColor = UIColor(hex: 0x979797)
  override func draw(_ rect: CGRect) {
    let marginX: CGFloat = 0
    let marginY: CGFloat = 0
    let startX = marginX
    let startY: CGFloat = 0
    let start = CGPoint(x: startX, y: startY)
    let originX: CGFloat = marginX
    let originY = rect.height - marginY
    let origin = CGPoint(x: originX, y: originY)
    let endX = rect.width
    let endY = originY
    let end = CGPoint(x: endX, y: endY)
    
    let path = UIBezierPath()
    path.move(to: start)
    path.addLine(to: origin)
    path.addLine(to: end)
    lineColor.setStroke()
    path.stroke()
  }
}
