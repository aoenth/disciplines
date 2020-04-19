//
//  ViewController.swift
//  Disciplines
//
//  Created by Kevin on 2017-09-12.
//  Copyright © 2017 Monorail Apps. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {
  let disciplineView = View()
  
  override func loadView() {
    self.view = disciplineView
    disciplineView.addTarget(self, selector: #selector(btnTapped))
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
  }
  
  @objc private func btnTapped(_ button: UIButton) {
    button.setTitleColor(UIColor.white.withAlphaComponent(0.2), for: .normal)
    button.backgroundColor = .clear
  }
  
  private func setupNavigationBar() {
    let barButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clear))
    navigationItem.rightBarButtonItem = barButtonItem
  }
  
  @objc private func clear() {
    disciplineView.resetButtons()
  }
}


