//
//  View.swift
//  Disciplines
//
//  Created by Kevin Peng on 2020-04-19.
//  Copyright © 2020 Monorail Apps. All rights reserved.
//

import UIKit

class View: UIView {
  
  override func layoutSubviews() {
    super.layoutSubviews()
    layoutViews()
  }
  
  var disciplinesText = [String]()
  
  private lazy var disciplines: [UIButton] = {
    var btns = [UIButton]()
    for text in disciplinesText {
      let btn = UIButton()
      btn.setTitle(text, for: .normal)
      btn.titleLabel?.numberOfLines = 0
      btn.titleLabel?.textAlignment = .center
      btn.layer.cornerRadius = 5
      btn.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.5)
      btns.append(btn)
    }
    return btns
  }()
  
  func addTarget(_ viewController: UIViewController, selector: Selector) {
    disciplines.forEach {
      $0.addTarget(viewController, action: selector, for: .touchUpInside)
    }
  }
  
  func resetButtons() {
    disciplines.forEach {
      $0.setTitleColor(.white, for: .normal)
      $0.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.5)
    }
  }
  
  private func layoutViews() {
    let stackView = UIStackView(arrangedSubviews: disciplines)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.spacing = 10
    addSubview(stackView)
    let salg = safeAreaLayoutGuide
    stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: salg.leadingAnchor, multiplier: 1).activate()
    salg.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 1).activate()
    stackView.topAnchor.constraint(equalToSystemSpacingBelow: salg.topAnchor, multiplier: 1).activate()
    salg.bottomAnchor.constraint(equalToSystemSpacingBelow: stackView.bottomAnchor, multiplier: 1).activate()
  }
}
