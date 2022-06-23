//
//  ListLikedGalleryCell.swift
//  MIEMApp
//
//  Created by Dmitry Korolev on 18.12.2021.
//

import UIKit

class ListLikedGalleryCell: UITableViewCell {
  
  static let reusedId = "ListLikedGalleryCell"
  
  var dataSource: CardDataModel?
  var requirementsStackView = UIStackView()
  var count = 0
  
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
  
  let vacancyLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: Brandbook.TextSize.largeNormal, weight: .regular)
    label.textAlignment = .left
    return label
  }()
  
  let vacancyLbl: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: Brandbook.TextSize.normal, weight: .bold)
    label.textAlignment = .right
    label.textColor = .systemBlue
    return label
  }()
  
  let requirementsTxt: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: Brandbook.TextSize.normal, weight: .bold)
    label.textAlignment = .right
    label.textColor = .systemBlue
    return label
  }()
  
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    addSubview(idLabel)
    addSubview(nameLabel)
    addSubview(vacancyLabel)
    addSubview(vacancyLbl)
    
    idLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding).isActive = true
    idLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: light).isActive = true
    
    nameLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: small_padding).isActive = true
    nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -small_padding).isActive = true
    nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: light).isActive = true
    
    vacancyLbl.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: padding).isActive = true
    vacancyLbl.leftAnchor.constraint(equalTo: leftAnchor, constant: light).isActive = true
    
    vacancyLabel.topAnchor.constraint(equalTo: vacancyLbl.bottomAnchor, constant: 5).isActive = true
    vacancyLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: light).isActive = true
    vacancyLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -small_padding).isActive = true
    
  }
  
  var height: CGFloat?
  
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
  
  private func measureFrameForText(_ text: String) -> CGRect{
    let size = CGSize(width: UIScreen.main.bounds.width-padding, height: 1000)
    let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
    return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
  }
}
private let padding = Brandbook.Paddings.normal //16
private let small_padding = Brandbook.Paddings.small //4
private let light = Brandbook.Paddings.light //8
