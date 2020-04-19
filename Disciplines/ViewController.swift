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
  
  var disciplinesTexts = [String]()
  
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
    setupNavigationBar()
    populateExistingData()
    createButtons()
    layoutViews()
  }
  
  private func setupNavigationBar() {
    let barButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clear))
    navigationItem.rightBarButtonItem = barButtonItem
    
    let leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewDiscipline))
    navigationItem.leftBarButtonItem = leftBarButtonItem
  }
  
  private func populateExistingData() {
    disciplinesTexts.append(contentsOf: DataManager.shared.getAllDisciplines())
  }
  
  private func createButtons() {
    disciplinesTexts.forEach {
      createAndAddButton($0)
    }
  }
  
  private func createAndAddButton(_ text: String) {
    let button = DisciplineButton(disciplineDescription: text)
    button.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
    stackView.addArrangedSubview(button)
  }
  
  private func layoutViews() {
    view.addSubview(stackView)
    let salg = view.safeAreaLayoutGuide
    stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: salg.leadingAnchor, multiplier: 1).activate()
    salg.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 1).activate()
    stackView.topAnchor.constraint(equalToSystemSpacingBelow: salg.topAnchor, multiplier: 1).activate()
    salg.bottomAnchor.constraint(equalToSystemSpacingBelow: stackView.bottomAnchor, multiplier: 1).activate()
  }
  
  @objc private func btnTapped(_ button: DisciplineButton) {
    button.isCompleted = true
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
      if let text = alertController.textFields?.first?.text {
        DataManager.shared.create(text) {
          self.disciplinesTexts.append(text)
          self.createAndAddButton(text)
        }
      }
    })
    
    present(alertController, animated: true, completion: nil)
  }
  
  
}


