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
    let originX: CGFloat = marginX
    let originY = rect.height - marginY
    let endX = rect.width
    let endY = originY
    
    lineColor.setStroke()
    let path = UIBezierPath()
    path.lineWidth = 1
    drawLine(path: path, originX: originX, endX: endX, endY: endY, percentage: 0)
    drawLine(path: path, originX: originX, endX: endX, endY: endY, percentage: 1)
    path.stroke()
    let subdividers = UIBezierPath()
    subdividers.lineWidth = 0.5
    drawLine(path: subdividers, originX: originX, endX: endX, endY: endY, percentage: 0.25)
    drawLine(path: subdividers, originX: originX, endX: endX, endY: endY, percentage: 0.50)
    drawLine(path: subdividers, originX: originX, endX: endX, endY: endY, percentage: 0.75)
    subdividers.stroke()
  }

  func drawLine(path: UIBezierPath, originX: CGFloat, endX: CGFloat, endY: CGFloat, percentage: CGFloat) {
    let lineHeight = endY * (1 - percentage)
    assert(lineHeight >= 0 && lineHeight <= endY, "percentage must be 0 <= percentage <= 1")
    let lineStart = CGPoint(x: originX, y: lineHeight)
    let lineEnd = CGPoint(x: endX, y: lineHeight)
    path.move(to: lineStart)
    path.addLine(to: lineEnd)
  }
}
