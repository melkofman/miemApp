//
//  ApplicationCell.swift
//  MIEMApp
//
//  Created by Melanie Kofman on 21.02.2021.
//

import UIKit

class ApplicationCell: UICollectionViewCell {
    static let reuseId = "ApplicationCell"
  
    let labelName: UILabel = {
      let label = UILabel()
      label.backgroundColor = .clear
      label.font = UIFont.systemFont(ofSize: 16)
      label.textAlignment = NSTextAlignment.left
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
    }()
  
  let studentComment: UITextView = {
    let textField = UITextView()
//  let studentComment: UILabel = {
//  let textField = UILabel()
//    textField.numberOfLines = 0
//    textField.sizeToFit()
//    textField.lineBreakMode = .byWordWrapping
    textField.backgroundColor = .clear
    textField.showsHorizontalScrollIndicator = false
    textField.showsVerticalScrollIndicator = false
    textField.isEditable = false
    textField.font = UIFont.systemFont(ofSize: 16)
    textField.textAlignment = NSTextAlignment.left
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
  }()
  
  let leaderComment: UITextView = {
    let textField = UITextView()
    textField.backgroundColor = .clear
    textField.showsHorizontalScrollIndicator = false
    textField.showsVerticalScrollIndicator = false
    textField.isEditable = false
    textField.font = UIFont.systemFont(ofSize: 16)
    textField.textAlignment = NSTextAlignment.left
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
  }()
  
  let groupLabel: UILabel = {
    let label = UILabel()
    label.backgroundColor = .clear
    label.font = UIFont.systemFont(ofSize: 16)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let roleLabel: UILabel = {
    let label = UILabel()
    label.backgroundColor = .clear
    label.font = UIFont.systemFont(ofSize: 16)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let projectNameLabel: UITextView = {
    let label = UITextView()
    label.isEditable = false
    label.backgroundColor = .clear
    label.showsVerticalScrollIndicator = false
    label.font = UIFont.boldSystemFont(ofSize: 16)
    label.showsHorizontalScrollIndicator = false
    label.textAlignment = NSTextAlignment.center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let leaderNameLabel: UILabel = {
    let label = UILabel()
    label.backgroundColor = .clear
    label.font = UIFont.systemFont(ofSize: 16)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let moreButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .clear
    button.setTitle("Подробнее", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.tintColor = .systemBlue
    return button
  }()
  
    override init(frame: CGRect) {
        super.init(frame: frame)
      backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
      clipsToBounds = true
      layer.cornerRadius = 9
      self.setShadow()
      
      addSubview(projectNameLabel)
      addSubview(labelName)
      addSubview(studentComment)
      addSubview(roleLabel)
      addSubview(groupLabel)
      addSubview(leaderComment)
      addSubview(moreButton)
    
    }
  
  func setup() {
    projectNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding).isActive = true
    projectNameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
    projectNameLabel.widthAnchor.constraint(equalToConstant: bounds.width - 2*padding).isActive = true
    projectNameLabel.heightAnchor.constraint(equalToConstant: measureFrameForText(self.projectNameLabel.text!).height+2*padding).isActive = true
    
    roleLabel.topAnchor.constraint(equalTo: projectNameLabel.bottomAnchor).isActive = true
    roleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
    roleLabel.widthAnchor.constraint(equalToConstant: bounds.width - 2*padding).isActive = true
    roleLabel.heightAnchor.constraint(equalToConstant: measureFrameForText(self.roleLabel.text!).height).isActive = true
    
    labelName.topAnchor.constraint(equalTo: roleLabel.bottomAnchor).isActive = true
    labelName.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
    labelName.widthAnchor.constraint(equalToConstant:bounds.width - 2*padding).isActive = true
    labelName.heightAnchor.constraint(equalToConstant:measureFrameForText(self.labelName.text!).height).isActive = true
    
    groupLabel.topAnchor.constraint(equalTo: labelName.bottomAnchor).isActive = true
    groupLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
    groupLabel.widthAnchor.constraint(equalToConstant: bounds.width - 2*padding).isActive = true
    groupLabel.heightAnchor.constraint(equalToConstant: measureFrameForText(self.groupLabel.text!).height).isActive = true
    
    moreButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding).isActive = true
    moreButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding).isActive = true
    
    studentComment.topAnchor.constraint(equalTo: groupLabel.bottomAnchor).isActive = true
    studentComment.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
    studentComment.widthAnchor.constraint(equalToConstant:bounds.width - 2*padding).isActive = true
    studentComment.bottomAnchor.constraint(equalTo: moreButton.topAnchor, constant: -padding).isActive = true

  }
  
    func setShadow(scale: Bool = true) {
      layer.masksToBounds = false
      layer.shadowColor = UIColor.black.cgColor
      layer.shadowOpacity = 0.4
      layer.shadowOffset = CGSize(width: -1, height: 8)
      layer.shadowRadius = 4

      layer.shadowPath = UIBezierPath(rect: bounds).cgPath
      layer.shouldRasterize = true
      layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
   
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func measureFrameForText(_ text: String) -> CGRect{
      let size = CGSize(width: 200, height: 1000)
      let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
      return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
  }
  
  
}
private let padding = Brandbook.Paddings.normal
