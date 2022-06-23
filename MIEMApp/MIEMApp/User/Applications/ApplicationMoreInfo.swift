//
//  ApplicationMoreInfo.swift
//  MIEMApp
//
//  Created by Melanie Kofman on 17.05.2021.
//

import UIKit
class ApplicationMoreInfo: UIViewController {
  let project_name: String
  let name: String
  let email: [String]
  let studentComment: String
  let leaderComment: String
  let group: String
  let role: String
  let leader: String
  
  init(project_name: String, name: String, email: [String], studentComment: String, leaderComment: String, group: String, role: String, leader: String) {
    self.project_name = project_name
    self.name = name
    self.email = email
    self.studentComment = studentComment
    self.leaderComment = leaderComment
    self.group = group
    self.role = role
    self.leader = leader
    super.init(nibName: nil, bundle: nil)
    setUp()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  let containerView: UIScrollView = {
    let view = UIScrollView()
    view.backgroundColor = .clear
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let projectNameView: UITextView = {
    let projectNameView = UITextView()
    projectNameView.isEditable = false
    projectNameView.backgroundColor = .clear
    projectNameView.showsVerticalScrollIndicator = false
    projectNameView.showsHorizontalScrollIndicator = false
    projectNameView.font = UIFont.boldSystemFont(ofSize: 16)
    projectNameView.textAlignment = NSTextAlignment.center
    projectNameView.translatesAutoresizingMaskIntoConstraints = false
    return projectNameView
  }()
  
  let roleLabel: UILabel = {
    let roleLabel = UILabel()
    roleLabel.backgroundColor = .clear
    roleLabel.font = UIFont.systemFont(ofSize: 16)
    roleLabel.translatesAutoresizingMaskIntoConstraints = false
    return roleLabel
  }()
  
  let studentNameLabel: UITextView = {
    let studentNameLabel = UITextView()
    studentNameLabel.backgroundColor = .clear
    studentNameLabel.showsHorizontalScrollIndicator = false
    studentNameLabel.showsVerticalScrollIndicator = false
    studentNameLabel.isEditable = false
    studentNameLabel.backgroundColor = .clear
    studentNameLabel.font = UIFont.systemFont(ofSize: 16)
    studentNameLabel.textAlignment = NSTextAlignment.left
    studentNameLabel.translatesAutoresizingMaskIntoConstraints = false
    return studentNameLabel
  }()
  
  let emailView: UITextView = {
    let emailView = UITextView()
    emailView.backgroundColor = .clear
    emailView.showsHorizontalScrollIndicator = false
    emailView.showsVerticalScrollIndicator = false
    emailView.isEditable = false
    emailView.font = UIFont.systemFont(ofSize: 16)
    emailView.textAlignment = NSTextAlignment.left
    emailView.translatesAutoresizingMaskIntoConstraints = false
    return emailView
  }()
  
  let groupLabel: UILabel = {
    let groupLabel = UILabel()
    groupLabel.backgroundColor = .clear
    groupLabel.font = UIFont.systemFont(ofSize: 16)
    groupLabel.translatesAutoresizingMaskIntoConstraints = false
    return groupLabel
  }()
  
  let leaderNameLabel: UITextView = {
    let leaderNameLabel = UITextView()
    leaderNameLabel.backgroundColor = .clear
    leaderNameLabel.showsHorizontalScrollIndicator = false
    leaderNameLabel.showsVerticalScrollIndicator = false
    leaderNameLabel.isEditable = false
    leaderNameLabel.font = UIFont.systemFont(ofSize: 16)
    leaderNameLabel.textAlignment = NSTextAlignment.left
    leaderNameLabel.translatesAutoresizingMaskIntoConstraints = false
    return leaderNameLabel
  }()
  
  let studentCommentView: UITextView = {
    let studentCommentView = UITextView()
    studentCommentView.backgroundColor = .clear
    studentCommentView.showsHorizontalScrollIndicator = false
    studentCommentView.showsVerticalScrollIndicator = false
    studentCommentView.isEditable = false
    studentCommentView.font = UIFont.systemFont(ofSize: 16)
    studentCommentView.textAlignment = NSTextAlignment.left
    studentCommentView.translatesAutoresizingMaskIntoConstraints = false
    return studentCommentView
  }()
  
  let leaderCommentView: UITextView = {
    let leaderCommentView = UITextView()
    leaderCommentView.backgroundColor = .clear
    leaderCommentView.showsHorizontalScrollIndicator = false
    leaderCommentView.showsVerticalScrollIndicator = false
    leaderCommentView.isEditable = false
    leaderCommentView.font = UIFont.systemFont(ofSize: 16)
    leaderCommentView.textAlignment = NSTextAlignment.center
    leaderCommentView.translatesAutoresizingMaskIntoConstraints = false
    return leaderCommentView
  }()
  
  func setUp() {
    self.view.addSubview(containerView)
    containerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
    containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
    containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    containerView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    
    containerView.addSubview(projectNameView)
    containerView.addSubview(roleLabel)
    containerView.addSubview(studentNameLabel)
    containerView.addSubview(groupLabel)
    containerView.addSubview(emailView)
    containerView.addSubview(studentCommentView)
    containerView.addSubview(leaderNameLabel)
    containerView.addSubview(leaderCommentView)

    projectNameView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding).isActive = true
    projectNameView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
    projectNameView.text = self.project_name
    projectNameView.widthAnchor.constraint(equalToConstant: measureFrameForText(projectNameView.text!).width).isActive = true
    projectNameView.heightAnchor.constraint(equalToConstant: measureFrameForText(projectNameView.text!).height+2*padding).isActive = true
    
    roleLabel.topAnchor.constraint(equalTo: projectNameView.bottomAnchor).isActive = true
    roleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: padding).isActive = true
    roleLabel.text = "Роль: " + self.role
    roleLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
    roleLabel.heightAnchor.constraint(equalToConstant: measureFrameForText(roleLabel.text!).height+padding/2).isActive = true

    studentNameLabel.topAnchor.constraint(equalTo: roleLabel.bottomAnchor).isActive = true
    studentNameLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: padding).isActive = true
    studentNameLabel.text = "Студент: " + self.name
    studentNameLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
    studentNameLabel.heightAnchor.constraint(equalToConstant: measureFrameForText(studentNameLabel.text!).height + padding/2).isActive = true
    
    emailView.topAnchor.constraint(equalTo: studentNameLabel.bottomAnchor).isActive = true
    emailView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: padding).isActive = true
    emailView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
    emailView.text = "email: "
    for i in self.email {
      emailView.text += i
    }
    emailView.heightAnchor.constraint(equalToConstant: measureFrameForText(emailView.text!).height).isActive = true
    
    groupLabel.topAnchor.constraint(equalTo: emailView.bottomAnchor).isActive = true
    groupLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: padding).isActive = true
    groupLabel.text = "Группа: " + self.group
    groupLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
    groupLabel.heightAnchor.constraint(equalToConstant: measureFrameForText(groupLabel.text!).height+padding/2).isActive = true

    studentCommentView.topAnchor.constraint(equalTo: groupLabel.bottomAnchor, constant: padding).isActive = true
    studentCommentView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: padding).isActive = true
    studentCommentView.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -padding).isActive = true
    studentCommentView.text = "Комментарий студента: \n" + self.studentComment
    studentCommentView.makeBold(originalText: studentCommentView.text!, boldText: "Комментарий студента: \n", normalText: self.studentComment)
    studentCommentView.heightAnchor.constraint(equalToConstant: measureFrameForText(studentCommentView.text!).height).isActive = true
    
    leaderNameLabel.topAnchor.constraint(equalTo: studentCommentView.bottomAnchor).isActive = true
    leaderNameLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: padding).isActive = true
    leaderNameLabel.text = "Руководитель: " + self.leader
    leaderNameLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -padding).isActive = true
    leaderNameLabel.heightAnchor.constraint(equalToConstant: measureFrameForText(leaderNameLabel.text!).height).isActive = true
    
    leaderCommentView.topAnchor.constraint(equalTo: leaderNameLabel.bottomAnchor, constant: padding).isActive = true
    leaderCommentView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: padding).isActive = true
    leaderCommentView.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -padding).isActive = true
    leaderCommentView.text = "Комментарий руководителя: \n" + self.leaderComment
    leaderCommentView.makeBold(originalText: leaderCommentView.text!, boldText: "Комментарий руководителя: \n", normalText: self.leaderComment)
    leaderCommentView.heightAnchor.constraint(equalToConstant: measureFrameForText(leaderCommentView.text!).height).isActive = true
    leaderCommentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
  }
  private func measureFrameForText(_ text: String) -> CGRect{
      let size = CGSize(width: 200, height: 1000)
      let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
      return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
  }
}
private let padding = Brandbook.Paddings.normal

extension UITextView {
  func makeBold(originalText: String, boldText: String, normalText: String) {

    let attributedOriginalText = NSMutableAttributedString(string: originalText)
    let boldRange = attributedOriginalText.mutableString.range(of: boldText)
    let normalRange = attributedOriginalText.mutableString.range(of: normalText)
    
    attributedOriginalText.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 16), range: boldRange)
    attributedOriginalText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16), range: normalRange)

      self.attributedText = attributedOriginalText
    }
}

