//
//  ProjectListCell.swift
//  MIEMApp
//
//  Created by Melanie Kofman on 12.11.2021.
//

import UIKit

class ProjectListCell: UITableViewCell {
  
  let idLabel: UILabel = {
      let label = UILabel()
      label.backgroundColor = .red
      label.font = UIFont.systemFont(ofSize: Brandbook.TextSize.largeNormal, weight: .bold)
      label.translatesAutoresizingMaskIntoConstraints = false
      label.textColor = .systemBlue
      return label
  }()
  
  let nameLabel: UITextView = {
      let label = UITextView()
      label.backgroundColor = .blue
      label.isEditable = false
      label.showsVerticalScrollIndicator = false
      label.showsHorizontalScrollIndicator = false
      label.textColor = .black
      label.translatesAutoresizingMaskIntoConstraints = false
      label.font = UIFont.systemFont(ofSize: Brandbook.TextSize.largeNormal, weight: .bold)
      label.textAlignment = NSTextAlignment.left
      return label
  }()
  
  let headLabel: UILabel = {
      let label = UILabel()
      label.translatesAutoresizingMaskIntoConstraints = false
      label.font = UIFont.systemFont(ofSize: Brandbook.TextSize.largeNormal, weight: .regular)
      label.textAlignment = .right
      return label
  }()
  
  let typeLabel: UILabel = {
      let label = UILabel()
      label.translatesAutoresizingMaskIntoConstraints = false
      label.font = UIFont.systemFont(ofSize: Brandbook.TextSize.normal, weight: .regular)
      label.textAlignment = .right
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
  
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      
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
      nameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75).isActive = true
      nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: light).isActive = true
      
      statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
      statusLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: light).isActive = true
      
      vacanciesLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 5).isActive = true
      vacanciesLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: light).isActive = true
    
      managerTxt.topAnchor.constraint(equalTo: vacanciesLabel.bottomAnchor, constant: 5).isActive = true
      managerTxt.leftAnchor.constraint(equalTo: leftAnchor, constant: light).isActive = true

      headLabel.topAnchor.constraint(equalTo: vacanciesLabel.bottomAnchor, constant: 5).isActive = true
      headLabel.leftAnchor.constraint(equalTo: managerTxt.rightAnchor, constant: small_padding).isActive = true
    
      typeTxt.topAnchor.constraint(equalTo: managerTxt.bottomAnchor, constant: 5).isActive = true
      typeTxt.leftAnchor.constraint(equalTo: leftAnchor, constant: light).isActive = true
      
      typeLabel.topAnchor.constraint(equalTo: managerTxt.bottomAnchor, constant: 5).isActive = true
      typeLabel.leftAnchor.constraint(equalTo: typeTxt.rightAnchor, constant: small_padding).isActive = true
      
      
      
  }
  
  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  private func measureFrameForText(_ text: String) -> CGRect{
      let size = CGSize(width: 200, height: 1000)
      let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
      return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
  }
  
}
private let padding = Brandbook.Paddings.normal
private let small_padding = Brandbook.Paddings.small
private let light = Brandbook.Paddings.light

