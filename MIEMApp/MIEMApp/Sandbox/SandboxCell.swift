//
//  SandboxCell.swift
//  MIEMApp
//
//  Created by Melanie Kofman on 10.03.2022.
//

import UIKit
class SandboxCell: UICollectionViewCell {
  
  static let reusedId = "SandboxCell"
  var status: String?
  
  let idLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: Brandbook.TextSize.largeNormal, weight: .bold)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .systemBlue
    return label
  }()
  
  let nameLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.sizeToFit()
    label.lineBreakMode = .byWordWrapping
    label.textColor = .black
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: Brandbook.TextSize.largeNormal, weight: .bold)
    label.textAlignment = NSTextAlignment.left
    label.backgroundColor = .clear
    return label
  }()
  
  let headLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: Brandbook.TextSize.largeNormal, weight: .regular)
    label.textColor = .black
    return label
  }()
  
  let statusLabel: UILabel = {
    let label = PaddingLabel()
    label.padding(2,2,4,4)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
    label.textAlignment = .right
    label.textColor = .white
    label.layer.masksToBounds = true
    label.layer.cornerRadius = 10
    return label
  }()
  
  let numVacancyLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
    return label
  }()
  
  let typeLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: Brandbook.TextSize.normal, weight: .regular)
    label.textAlignment = .right
    label.textColor = .black
    return label
  }()
  
  let managerTxt: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: Brandbook.TextSize.normal, weight: .bold)
    label.textAlignment = .right
    label.textColor = .systemBlue
    return label
  }()
  
  let typeTxt: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: Brandbook.TextSize.normal, weight: .bold)
    label.textAlignment = .right
    label.textColor = .systemBlue
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(idLabel)
    addSubview(nameLabel)
    addSubview(statusLabel)
    addSubview(numVacancyLabel)
    addSubview(managerTxt)
    addSubview(headLabel)
    addSubview(typeTxt)
    addSubview(typeLabel)
    
    idLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding).isActive = true
    idLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: light).isActive = true
    
    nameLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: small_padding).isActive = true
    nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -small_padding).isActive = true
    nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: light).isActive = true
    
    statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
    statusLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: light).isActive = true
    
    numVacancyLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 5).isActive = true
    numVacancyLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: light).isActive = true
    
    managerTxt.topAnchor.constraint(equalTo: numVacancyLabel.bottomAnchor, constant: padding).isActive = true
    managerTxt.leftAnchor.constraint(equalTo: leftAnchor, constant: light).isActive = true
    
    headLabel.topAnchor.constraint(equalTo: managerTxt.bottomAnchor, constant: 5).isActive = true
    headLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: light).isActive = true
    headLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -small_padding).isActive = true
    
    typeTxt.topAnchor.constraint(equalTo: headLabel.bottomAnchor, constant: padding).isActive = true
    typeTxt.leftAnchor.constraint(equalTo: leftAnchor, constant: light).isActive = true
    
    typeLabel.topAnchor.constraint(equalTo: headLabel.bottomAnchor, constant: padding).isActive = true
    typeLabel.leftAnchor.constraint(equalTo: typeTxt.rightAnchor, constant: small_padding).isActive = true
    
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.clipsToBounds = false
    self.layer.cornerRadius = 5
    self.layer.shadowRadius = 5
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

