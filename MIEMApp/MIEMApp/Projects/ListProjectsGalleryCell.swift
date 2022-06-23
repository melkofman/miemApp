//
//  ListProjectsGalleryCell.swift
//  MIEMApp
//
//  Created by Melanie Kofman on 17.11.2021.
//

import UIKit

class ListProjectsGalleryCell: UICollectionViewCell {
  
  static let reusedId = "ListProjectsGalleryCell"
  
  let idLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: Brandbook.TextSize.largeNormal, weight: .bold)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .systemBlue
    return label
  }()
  
  
  let nameLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 4
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
    label.textAlignment = .left
    label.textColor = .black
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
  
  let statusLabel: UILabel = {
    let label = PaddingLabel()
    label.padding(2,2,4,4)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
    label.textAlignment = .right
    label.textColor = .white
    label.layer.masksToBounds = true
    label.layer.cornerRadius = 10
    label.backgroundColor = Brandbook.Colors.greenStatus
    return label
  }()
  
  let vacanciesLabel: UILabel = {
    let label = PaddingLabel()
    label.padding(2,2,4,4)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
    label.textAlignment = .right
    label.textColor = .white
    label.layer.masksToBounds = true
    label.layer.cornerRadius = 10
    label.backgroundColor = Brandbook.Colors.blueStatus
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
    addSubview(headLabel)
    addSubview(typeLabel)
    addSubview(statusLabel)
    addSubview(vacanciesLabel)
    addSubview(managerTxt)
    addSubview(typeTxt)
    
    idLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding).isActive = true
    idLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: light).isActive = true
    
    nameLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: small_padding).isActive = true
    nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -small_padding).isActive = true
    nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: light).isActive = true
    
    statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
    statusLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: light).isActive = true
    
    vacanciesLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 5).isActive = true
    vacanciesLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: light).isActive = true
    
    managerTxt.topAnchor.constraint(equalTo: vacanciesLabel.bottomAnchor, constant: padding).isActive = true
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
    self.layer.shadowOffset = CGSize(width: 3, height: 3)
    self.layer.shadowOpacity = 0.2
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  private func measureFrameForText(_ text: String) -> CGRect{
    let size = CGSize(width: UIScreen.main.bounds.width-padding, height: 1000)
    let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
    return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
  }
  
  
  
}
private let padding = Brandbook.Paddings.normal //16
private let small_padding = Brandbook.Paddings.small //4
private let light = Brandbook.Paddings.light //8
