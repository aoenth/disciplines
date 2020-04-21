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
  
  var disciplines = [Discipline]()
  var activatedButton: UIButton?
  var widthConstraint: NSLayoutConstraint?
  var doneButtonConstraints = [NSLayoutConstraint]()
  var dragging = false
  
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.spacing = 10
    return stackView
  }()
  
  private lazy var doneButton: DoneButton = {
    let btn = DoneButton()
    btn.isHidden = true
    btn.translatesAutoresizingMaskIntoConstraints = false
    btn.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
    return btn
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupBackground()
    setupNavigationBar()
    populateExistingData()
    createButtons()
    layoutViews()
  }
  
  private func setupBackground() {
    view.backgroundColor = .white
  }
  
  private func setupNavigationBar() {
    let barButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clear))
    navigationItem.rightBarButtonItem = barButtonItem
    
    let leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewDiscipline))
    navigationItem.leftBarButtonItem = leftBarButtonItem
  }
  
  private func populateExistingData() {
    disciplines.append(contentsOf: DataManager.shared.getAllDisciplines())
  }
  
  private func createButtons() {
    disciplines.forEach {
      createAndAddButton($0)
    }
  }
  
  private func createAndAddButton(_ discipline: Discipline) {
    let button = DisciplineButton(discipline: discipline)
    button.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
    addSwipeForDone(button)
    stackView.addArrangedSubview(button)
  }
  
  func addSwipeForDone(_ button: UIButton) {
    let pan = UIPanGestureRecognizer(target: self, action: #selector(btnSwipeLeft))
    button.addGestureRecognizer(pan)
  }
  
  private func layoutViews() {
    view.addSubview(stackView)
    view.addSubview(doneButton)
    let salg = view.safeAreaLayoutGuide
    stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: salg.leadingAnchor, multiplier: 1).activate()
    salg.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 1).activate()
    stackView.topAnchor.constraint(equalToSystemSpacingBelow: salg.topAnchor, multiplier: 1).activate()
    salg.bottomAnchor.constraint(equalToSystemSpacingBelow: stackView.bottomAnchor, multiplier: 1).activate()
  }
  
  @objc private func btnTapped() {
    guard let btn = activatedButton else {
      return
    }
    restoreToIdentityTransformation(btn, newButtonSwiped: false)
  }
  
  @objc private func doneButtonPressed() {
    guard let btn = activatedButton as? DisciplineButton else {
      return
    }
    if let discipline = btn.discipline {
      DataManager.shared.complete(discipline: discipline) {
        self.activatedButton?.setNeedsLayout()
        self.activatedButton?.layoutIfNeeded()
      }
    }
    btnTapped()
  }
  
  @objc private func btnSwipeLeft(_ gesture: UIPanGestureRecognizer) {
    guard let button = gesture.view as? DisciplineButton else {
      return
    }
    
    let tx =  button.transform.tx
    let leftSwiped = tx <= -80
    let rightSwiped = tx >= 80
    let swipingLeft = gesture.velocity(in: view).x < 0
    let swipingRight = !swipingLeft
    let shouldRestoreLeft = tx < 80 && tx > 0 && swipingLeft
    let shouldRestoreRight = tx > -80 && tx < 0 && swipingRight
    let translationX: CGFloat
    
    if gesture.state == .began {
      if let btn = activatedButton, button != btn {
        restoreToIdentityTransformation(btn, newButtonSwiped: true)
        return
      } else {
        translationX = gesture.translation(in: view).x + tx
      }
    } else {
      translationX = gesture.translation(in: view).x
    }
    
    if gesture.state == .ended {
      let tx = button.transform.tx
      if let btn = activatedButton {
        UIView.animate(withDuration: 0.1) {
          btn.transform = CGAffineTransform(translationX: tx > 0 ? 80 : -80, y: 0)
          self.widthConstraint?.constant = 80 - 8
        }
      }
      dragging = false
      return
    }
    
    if shouldRestoreLeft || shouldRestoreRight {
      dragging = false
      gesture.state = .ended
      restoreToIdentityTransformation(button, newButtonSwiped: false)
      return
    } else if leftSwiped || rightSwiped {
      let translationValue = min(120 / abs(translationX), 1)
      let directionMultiplier: CGFloat = swipingLeft ? -1 : 1
      let dx = directionMultiplier * translationValue
      button.transform = button.transform.translatedBy(x: dx, y: 0)
    } else {
      button.transform = CGAffineTransform(translationX: translationX, y: 0)
    }
    
    activatedButton = button
    updateButton(tx, left: tx == 0 ? swipingLeft : leftSwiped)
  }
  
  private func restoreToIdentityTransformation(_ button: UIButton, newButtonSwiped: Bool) {
    widthConstraint?.constant = 0
    UIView.animate(withDuration: 0.2) {
      button.transform = .identity
      if !newButtonSwiped {
        self.view.layoutIfNeeded()
      }
    }
    activatedButton = nil
  }
  
  func updateButton(_ tx: CGFloat, left: Bool) {
    if let activeButton = activatedButton, dragging == false {
      doneButton.isHidden = false
      removeAllConstraints()
      createConstraints(toButton: activeButton, left: left)
      dragging = true
    }
    widthConstraint?.constant = max(abs(tx) - 8, 0)
  }
  
  func createConstraints(toButton activeButton: UIButton, left: Bool) {
    let top = doneButton.topAnchor.constraint(equalTo: activeButton.topAnchor)
    let leading: NSLayoutConstraint
    if left {
      leading = stackView.trailingAnchor.constraint(equalTo: doneButton.trailingAnchor)
    } else {
      leading = stackView.leadingAnchor.constraint(equalTo: doneButton.leadingAnchor)
    }
    let width = doneButton.widthAnchor.constraint(equalToConstant: 0)
    let bottom = activeButton.bottomAnchor.constraint(equalTo: doneButton.bottomAnchor)
    doneButtonConstraints = [top, leading, width, bottom]
    doneButtonConstraints.forEach {
      $0.activate()
    }
    widthConstraint = width
  }
  
  
  func removeAllConstraints() {
    doneButtonConstraints.forEach {
      $0.isActive = false
    }
    doneButtonConstraints.removeAll(keepingCapacity: true)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let btn = activatedButton {
      restoreToIdentityTransformation(btn, newButtonSwiped: false)
    }
  }
  
  
  @objc private func clear() {
    stackView.arrangedSubviews.forEach {
      if let btn = $0 as? DisciplineButton, let discipline = btn.discipline {
        DataManager.shared.removeCompletion(discipline: discipline)
        btn.setNeedsLayout()
        btn.layoutIfNeeded()
      }
    }
    
  }
  
  @objc private func addNewDiscipline() {
    let alertController = UIAlertController(title: "New Discipline",
                                            message: "Enter a description for a new discipline",
                                            preferredStyle: .alert)
    
    alertController.addTextField { (textField) in
      textField.placeholder = "Wake up at 4:30AM"
    }
    
    alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
      if let text = alertController.textFields?.first?.text, !text.isEmpty {
        DataManager.shared.create(text) { newDiscipline in
          self.disciplines.append(newDiscipline)
          self.createAndAddButton(newDiscipline)
        }
      }
    })
    
    alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
    
    present(alertController, animated: true, completion: nil)
  }
  
  
}


