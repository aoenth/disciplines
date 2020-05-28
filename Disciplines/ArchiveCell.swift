//
//  ArchiveCell.swift
//  Disciplines
//
//  Created by Kevin Peng on 2020-04-25.
//  Copyright © 2020 Monorail Apps. All rights reserved.
//

import UIKit
class ArchiveCell: UITableViewCell {
  
  private lazy var nameLabel: AKLabel = {
    let lbl = AKLabel()
    lbl.maxSizeFontOverride = 36
    lbl.translatesAutoresizingMaskIntoConstraints = false
    lbl.textAlignment = .center
    return lbl
  }()
  
  private lazy var countLabel: UILabel = {
    let lbl = UILabel()
    lbl.translatesAutoresizingMaskIntoConstraints = false
    lbl.textColor = .white
    lbl.font = .systemFont(ofSize: 16)
    return lbl
  }()
  
  private lazy var dateLabel: UILabel = {
    let lbl = UILabel()
    lbl.translatesAutoresizingMaskIntoConstraints = false
    lbl.setContentHuggingPriority(.defaultHigh, for: .vertical)
    lbl.font = .systemFont(ofSize: 16)
    lbl.textColor = .white
    return lbl
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    applyStyles()
    layoutViews()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    applyStyles()
    layoutViews()
  }
  
  private func applyStyles() {
    backgroundColor = UIColor(hex: 0x6DD400)
  }
  
  override func layoutSubviews() {
    layer.cornerRadius = 8
  }
  
  func configure(name: String, date: String, count: String) {
    let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.white]
    nameLabel.attributedText = NSAttributedString(string: name, attributes: attributes)
    dateLabel.text = "Since " + date
    
    countLabel.text = "Completed \(count)×"
  }
  
  func layoutViews() {
    addSubview(nameLabel)
    nameLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1).activate()
    nameLabel.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 2).activate()
    trailingAnchor.constraint(equalToSystemSpacingAfter: nameLabel.trailingAnchor, multiplier: 1).activate()
    
    
    addSubview(dateLabel)
    dateLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1).activate()
    bottomAnchor.constraint(equalToSystemSpacingBelow: dateLabel.bottomAnchor, multiplier: 1).activate()
    
    
    addSubview(countLabel)
    countLabel.lastBaselineAnchor.constraint(equalTo: dateLabel.lastBaselineAnchor).activate()
    trailingAnchor.constraint(equalToSystemSpacingAfter: countLabel.trailingAnchor, multiplier: 1).activate()
    
    dateLabel.topAnchor.constraint(equalToSystemSpacingBelow: nameLabel.bottomAnchor, multiplier: 2).activate()
  }
}
