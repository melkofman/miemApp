//
//  ProjectCell.swift
//  MIEMApp
//
//  Created by Melanie Kofman on 21.02.2021.
//

import UIKit

class ProjectCell: UICollectionViewCell {

  static let reuseId = "ProjectCell"
  
  let labelNumber: UILabel = {
    let label = UILabel()
    label.textAlignment = NSTextAlignment.center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
//  let labelName: UITextView = {
//    let label = UITextView()
  let labelName: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.sizeToFit()
    label.lineBreakMode = .byWordWrapping
    label.backgroundColor = .clear
//    label.isEditable = false
//    label.showsVerticalScrollIndicator = false
//    label.showsHorizontalScrollIndicator = false
    label.font = UIFont.boldSystemFont(ofSize: 16)
    label.textAlignment = NSTextAlignment.left
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let labelStatus: UILabel = {
    let label = UILabel()
    label.backgroundColor = Brandbook.Colors.greenStatus
    label.clipsToBounds = true
    label.layer.cornerRadius = 6
    label.textAlignment = NSTextAlignment.center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let labelType: UILabel = {
    let label = UILabel()
    label.text = "Тип: "
    label.textAlignment = NSTextAlignment.left
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
//  let labelHead: UITextView = {
//    let label = UITextView()
  let labelHead: UILabel = {
  let label = UILabel()
    label.numberOfLines = 0
    label.sizeToFit()
    label.lineBreakMode = .byWordWrapping
    label.backgroundColor = .clear
//    label.isEditable = false
//    label.showsVerticalScrollIndicator = false
//    label.showsHorizontalScrollIndicator = false
    label.font = UIFont.systemFont(ofSize: 17)
    label.textAlignment = NSTextAlignment.left
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
//  let labelRole: UITextView = {
//    let label = UITextView()
  let labelRole: UILabel = {
     let label = UILabel()
    label.numberOfLines = 0
    label.sizeToFit()
    label.lineBreakMode = .byWordWrapping
    label.backgroundColor = .clear
//    label.isEditable = false
//    label.showsVerticalScrollIndicator = false
//    label.showsHorizontalScrollIndicator = false
    label.font = UIFont.systemFont(ofSize: 17)
    label.text = "Роль: "
    label.textAlignment = NSTextAlignment.left
    
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let labelPart: UILabel = {
    let label = UILabel()
    label.text = "Участники: "
    label.textAlignment = NSTextAlignment.left
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let labelHours: UILabel = {
    let label = UILabel()
    label.text = "Часы: "
    label.textAlignment = NSTextAlignment.left
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
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
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
    clipsToBounds = true
    layer.cornerRadius = 9
    self.setShadow()
    addSubview(labelNumber)
    addSubview(labelName)
    addSubview(labelStatus)
    addSubview(labelType)
    addSubview(labelHead)
    addSubview(labelRole)
    addSubview(labelPart)
    addSubview(labelHours)
    
  }
  
  func setUp() {
    labelNumber.topAnchor.constraint(equalTo: topAnchor, constant: padding).isActive = true
    labelNumber.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
    
    labelName.topAnchor.constraint(equalTo: labelNumber.bottomAnchor).isActive = true
    labelName.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
    labelName.widthAnchor.constraint(equalToConstant: measureFrameForText(self.labelName.text!).width + padding).isActive = true
    labelName.heightAnchor.constraint(equalToConstant: measureFrameForText(self.labelName.text!).height + padding).isActive = true
    
    labelStatus.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: padding/2).isActive = true
    labelStatus.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
    labelStatus.widthAnchor.constraint(equalToConstant: measureFrameForText(self.labelStatus.text!).width + padding).isActive = true
    labelStatus.heightAnchor.constraint(equalToConstant: measureFrameForText(self.labelStatus.text!).height).isActive = true
    
    labelType.topAnchor.constraint(equalTo: labelStatus.bottomAnchor, constant: padding/2).isActive = true
    labelType.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
    labelType.widthAnchor.constraint(equalToConstant: measureFrameForText(self.labelType.text!).width + padding).isActive = true
    labelType.heightAnchor.constraint(equalToConstant: measureFrameForText(self.labelType.text!).height).isActive = true
    
    labelHead.topAnchor.constraint(equalTo: labelType.bottomAnchor).isActive = true
    labelHead.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
    labelHead.widthAnchor.constraint(equalToConstant: measureFrameForText(self.labelHead.text!).width + padding).isActive = true
    labelHead.heightAnchor.constraint(equalToConstant: measureFrameForText(self.labelHead.text!).height + padding).isActive = true
    
    labelRole.topAnchor.constraint(equalTo: labelHead.bottomAnchor).isActive = true
    labelRole.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
    labelRole.widthAnchor.constraint(equalToConstant: measureFrameForText(self.labelRole.text!).width + padding).isActive = true
//    labelRole.contentInset = UIEdgeInsets(top: measureFrameForText(self.labelRole.text!).width, left: 0, bottom: 0, right: 0)
    labelRole.heightAnchor.constraint(equalToConstant: measureFrameForText(self.labelRole.text!).height + padding).isActive = true
    
    labelPart.topAnchor.constraint(equalTo: labelRole.bottomAnchor, constant: padding/2).isActive = true
    labelPart.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
    labelPart.widthAnchor.constraint(equalToConstant: measureFrameForText(self.labelPart.text!).width + padding).isActive = true
    labelPart.heightAnchor.constraint(equalToConstant: measureFrameForText(self.labelPart.text!).height).isActive = true

    labelHours.topAnchor.constraint(equalTo: labelPart.bottomAnchor, constant: padding/2).isActive = true
    labelHours.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
    labelHours.widthAnchor.constraint(equalToConstant: measureFrameForText(self.labelHours.text!).width + padding).isActive = true
    labelHours.heightAnchor.constraint(equalToConstant: measureFrameForText(self.labelHours.text!).height).isActive = true

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
