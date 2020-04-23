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
  var activatedButtonConstraints = [NSLayoutConstraint]()
  var dragging = false
  
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.spacing = 16
    return stackView
  }()
  
  private lazy var doneButton: DoneButton = {
    let btn = DoneButton()
    btn.isHidden = true
    btn.translatesAutoresizingMaskIntoConstraints = false
    btn.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
    return btn
  }()
  
  private lazy var archiveButton: ArchiveButton = {
    let button = ArchiveButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.isHidden = true
    button.addTarget(self, action: #selector(archiveButtonPressed), for: .touchUpInside)
    return button
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
    let pan = UIPanGestureRecognizer(target: self, action: #selector(btnSwipe))
    button.addGestureRecognizer(pan)
  }
  
  private func layoutViews() {
    view.addSubview(stackView)
    view.addSubview(doneButton)
    view.addSubview(archiveButton)
    let salg = view.safeAreaLayoutGuide
    stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: salg.leadingAnchor, multiplier: 2).activate()
    salg.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 2).activate()
    stackView.topAnchor.constraint(equalToSystemSpacingBelow: salg.topAnchor, multiplier: 2).activate()
    salg.bottomAnchor.constraint(equalToSystemSpacingBelow: stackView.bottomAnchor, multiplier: 2).activate()
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
  
  @objc private func archiveButtonPressed() {
    guard let btn = activatedButton as? DisciplineButton else {
      return
    }
    
    if let index = disciplines.firstIndex(of: btn.discipline) {
      disciplines.remove(at: index)
      stackView.removeArrangedSubview(btn)
      btn.removeFromSuperview()
      UIView.animate(withDuration: 0.2) {
        self.stackView.layoutIfNeeded()
      }
    }
    
    DataManager.shared.delete(discipline: btn.discipline)
    activatedButton = nil
    archiveButton.isHidden = true
  }
  
  @objc private func btnSwipe(_ gesture: UIPanGestureRecognizer) {
    guard let button = gesture.view as? DisciplineButton else {
      return
    }
    
    let tx =  button.transform.tx
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
        self.widthConstraint?.constant = 80 - 8
        UIView.animate(withDuration: 0.1) {
          btn.transform = CGAffineTransform(translationX: tx > 0 ? 80 : -80, y: 0)
          self.view.layoutIfNeeded()
        }
      }
      dragging = false
      return
    }
    
    guard abs(translationX) > 10 else {
      return
    }
    
    let leftSwiped = tx <= -80
    let rightSwiped = tx >= 80
    let swipingLeft = gesture.velocity(in: view).x < 0
    let swipingRight = !swipingLeft
    let shouldRestoreLeft = tx < 80 && tx > 0 && swipingLeft
    let shouldRestoreRight = tx > -80 && tx < 0 && swipingRight
    
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
    widthConstraint?.constant = max(abs(tx) - 8, 0)
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
    guard let activeButton = activatedButton, dragging == false else {
      return
    }
    
    removeAllConstraints()
    dragging = true
    if left == true {
      createConstraints(to: activeButton, from: doneButton, left: left)
      view.layoutIfNeeded()
      doneButton.isHidden = false
    } else {
      createConstraints(to: activeButton, from: archiveButton, left: left)
      view.layoutIfNeeded()
      archiveButton.isHidden = false
    }
    
  }
  
  func createConstraints(to activeButton: UIButton, from actionButton: UIButton, left: Bool) {
    let top = actionButton.topAnchor.constraint(equalTo: activeButton.topAnchor)
    let leading: NSLayoutConstraint
    if left {
      leading = stackView.trailingAnchor.constraint(equalTo: actionButton.trailingAnchor)
    } else {
      leading = stackView.leadingAnchor.constraint(equalTo: actionButton.leadingAnchor)
    }
    let width = actionButton.widthAnchor.constraint(equalToConstant: 0)
    let bottom = activeButton.bottomAnchor.constraint(equalTo: actionButton.bottomAnchor)
    activatedButtonConstraints = [top, leading, width, bottom]
    activatedButtonConstraints.forEach {
      $0.activate()
    }
    widthConstraint = width
  }
  
  
  func removeAllConstraints() {
    activatedButtonConstraints.forEach {
      $0.isActive = false
    }
    activatedButtonConstraints.removeAll(keepingCapacity: true)
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
                                            message: "Enter a description for a new discipline.",
                                            preferredStyle: .alert)
    
    alertController.addTextField { [weak self] (textField) in
      textField.placeholder = "Wake up at 4:30AM"
      textField.autocapitalizationType = .sentences
      textField.delegate = self
    }
    
    alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
    alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
      if let text = alertController.textFields?.first?.text, !text.isEmpty {
        self.handleCreateNewDiscipline(text)
      }
    })
    
    
    present(alertController, animated: true, completion: nil)
  }
  
  private func handleCreateNewDiscipline(_ text: String) {
    DataManager.shared.create(text) { newDiscipline in
      self.disciplines.append(newDiscipline)
      self.createAndAddButton(newDiscipline)
    }
  }
  
  
}

extension ViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let text = textField.text, !text.isEmpty {
      handleCreateNewDiscipline(text)
    }
    dismiss(animated: true, completion: nil)
    return true
  }
  
}

