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
  
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.spacing = 10
    return stackView
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
      createAndAddButton($0.shortText)
    }
  }
  
  private func createAndAddButton(_ text: String) {
    let button = DisciplineButton(disciplineDescription: text)
    addSwipeForDone(button)
    stackView.addArrangedSubview(button)
  }
  
  func addSwipeForDone(_ button: UIButton) {
    let pan = UIPanGestureRecognizer(target: self, action: #selector(btnSwipeLeft))
    button.addGestureRecognizer(pan)
  }
  
  private func layoutViews() {
    view.addSubview(stackView)
    let salg = view.safeAreaLayoutGuide
    stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: salg.leadingAnchor, multiplier: 1).activate()
    salg.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 1).activate()
    stackView.topAnchor.constraint(equalToSystemSpacingBelow: salg.topAnchor, multiplier: 1).activate()
    salg.bottomAnchor.constraint(equalToSystemSpacingBelow: stackView.bottomAnchor, multiplier: 1).activate()
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
        restoreToIdentityTransformation(btn)
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
        }
      }
      return
    }
    
    if shouldRestoreLeft || shouldRestoreRight {
      gesture.state = .ended
      restoreToIdentityTransformation(button)
    } else if leftSwiped || rightSwiped {
      let translationValue = min(120 / abs(translationX), 1)
      let directionMultiplier: CGFloat = swipingLeft ? -1 : 1
      let dx = directionMultiplier * translationValue
      print(directionMultiplier, translationValue, dx)
      button.transform = button.transform.translatedBy(x: dx, y: 0)
      activatedButton = button
    } else {
      button.transform = CGAffineTransform(translationX: translationX, y: 0)
      activatedButton = button
    }
  }
  
  private func restoreToIdentityTransformation(_ button: UIButton) {
    UIView.animate(withDuration: 0.1) {
      button.transform = .identity
    }
    activatedButton = nil
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let btn = activatedButton {
      UIView.animate(withDuration: 0.5) {
        btn.transform = .identity
      }
      return
    }
  }
  
  
  @objc private func clear() {
    stackView.arrangedSubviews.forEach {
      if let btn = $0 as? DisciplineButton {
        btn.isCompleted = false
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
          self.createAndAddButton(newDiscipline.shortText)
        }
      }
    })
    
    alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
    
    present(alertController, animated: true, completion: nil)
  }
  
  
}


