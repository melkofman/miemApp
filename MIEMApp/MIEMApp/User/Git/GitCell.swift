//
//  GitCell.swift
//  MIEMApp
//
//  Created by Melanie Kofman on 03.02.2022.
//

import Foundation
import UIKit

class GitCell: UICollectionViewCell {
  static let reusedId = "GitCell"
  
  let nameLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = NSTextAlignment.justified
    label.numberOfLines = 0
    label.textColor = Brandbook.Colors.beige
    label.sizeToFit()
    label.lineBreakMode = .byWordWrapping
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let comitNumberText: UILabel = {
    let label = UILabel()
    label.textAlignment = NSTextAlignment.justified
    label.text = "Количество коммитов: "
    label.textColor = Brandbook.Colors.beige
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let comitNumber: UILabel = {
    let label = UILabel()
    label.textAlignment = NSTextAlignment.justified
    label.textColor = Brandbook.Colors.beige
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(nameLabel)
    addSubview(comitNumberText)
    addSubview(comitNumber)
    
    nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: light).isActive = true
    nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
    nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding).isActive = true
    
    comitNumberText.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: light).isActive = true
    comitNumberText.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
    
    comitNumber.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: light).isActive = true
    comitNumber.leftAnchor.constraint(equalTo: comitNumberText.rightAnchor, constant: small_padding).isActive = true
    
    clipsToBounds = false
    backgroundColor = Brandbook.Colors.lightBlue
    layer.cornerRadius = 5
    layer.shadowRadius = 5
    layer.shadowOffset = CGSize(width: 3, height: 3)
    layer.shadowOpacity = 0.2
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}

private let padding = Brandbook.Paddings.normal //16
private let small_padding = Brandbook.Paddings.small //4
private let light = Brandbook.Paddings.light //8
