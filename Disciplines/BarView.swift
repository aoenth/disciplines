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
  
  private lazy var bar: UIView = {
    let v = UIView()
    v.translatesAutoresizingMaskIntoConstraints = false
    v.backgroundColor = UIColor(hex: 0x6DD400)
    return v
  }()
  
  private lazy var label: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    let percentText = String(format: "%0.0f", percent * 100)
    label.text = percentText + " %"
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 10)
    return label
  }()
  
  convenience init(percent: Double) {
    self.init()
    self.percent = percent
    applyStyles()
    layoutCompletionBar()
  }
  
  private func layoutCompletionBar() {
    addSubview(bar)
    bar.leftAnchor.constraint(equalToSystemSpacingAfter: leftAnchor, multiplier: 0).activate()
    rightAnchor.constraint(equalToSystemSpacingAfter: bar.rightAnchor, multiplier: 0).activate()
    bottomAnchor.constraint(equalToSystemSpacingBelow: bar.bottomAnchor, multiplier: 0).activate()

    let multiplier = CGFloat(percent)
    bar.heightAnchor.constraint(equalTo: heightAnchor, multiplier: multiplier).activate()
    
    
    guard percent > 0 else {
      return
    }
    
    addSubview(label)
    label.leadingAnchor.constraint(equalToSystemSpacingAfter: bar.leadingAnchor, multiplier: 0).activate()
    bar.trailingAnchor.constraint(equalToSystemSpacingAfter: label.trailingAnchor, multiplier: 0).activate()
    
    
    if percent >= 0.5 {
      label.topAnchor.constraint(equalToSystemSpacingBelow: bar.topAnchor, multiplier: 1).activate()
    } else {
      bar.topAnchor.constraint(equalToSystemSpacingBelow: label.bottomAnchor, multiplier: 1).activate()
    }
    
  }
  
  private func applyStyles() {
    backgroundColor = .clear
  }
}
