//
//  TutorialView.swift
//  MIEMApp
//
//  Created by Тимофей Фёдоров on 14.03.2021.
//

import UIKit

final class TutorialView: UIView {
  private let pageModel: TutorialPageViewModel
  private let buttonText: String
  private let closeAction: () -> Void
  private let buttonAction: () -> Void
  
  init(
    pageModel: TutorialPageViewModel,
    buttonText: String,
    closeAction: @escaping () -> Void,
    buttonAction: @escaping () -> Void
  ) {
    self.pageModel = pageModel
    self.buttonText = buttonText
    self.closeAction = closeAction
    self.buttonAction = buttonAction
    super.init(frame: .zero)
    setUpViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUpViews() {
    backgroundColor = .white
    
    let closeButton = UIButton()
    closeButton.addTarget(self, action: #selector(onCloseClicked), for: .touchUpInside)
    closeButton.setImage(Brandbook.Images.Icons.closeIcon, for: .normal)
    closeButton.tintColor = Brandbook.Colors.grey
    addSubview(closeButton)
    closeButton.translatesAutoresizingMaskIntoConstraints = false
    closeButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
    closeButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
    closeButton.topAnchor.constraint(equalTo: topAnchor, constant: padding).isActive = true
    closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding).isActive = true
    
    let title = UILabel()
    title.font = title.font.withSize(Brandbook.TextSize.large).bold
    title.numberOfLines = 1
    title.text = pageModel.title
    addSubview(title)
    title.translatesAutoresizingMaskIntoConstraints = false
    title.topAnchor.constraint(equalTo: closeButton.topAnchor).isActive = true
    title.bottomAnchor.constraint(equalTo: closeButton.bottomAnchor).isActive = true
    title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding).isActive = true
    title.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -padding).isActive = true
    
    let button = Button(buttonText)
    button.addTarget(self, action: #selector(onButtonClicked), for: .touchUpInside)
    addSubview(button)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding).isActive = true
    button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding).isActive = true
    button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding).isActive = true

    let label = UILabel()
    label.font = label.font.withSize(Brandbook.TextSize.normal)
    label.numberOfLines = 0
    label.text = pageModel.text
    addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -padding).isActive = true
    label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding).isActive = true
    label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding).isActive = true
    
    let image = UIImageView(image: pageModel.image)
    image.contentMode = .scaleAspectFit
    addSubview(image)
    image.translatesAutoresizingMaskIntoConstraints = false
    image.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: padding).isActive = true
    image.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -padding).isActive = true
    image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding).isActive = true
    image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding).isActive = true
  }
  
  @objc private func onCloseClicked() {
    closeAction()
  }
  
  @objc private func onButtonClicked() {
    buttonAction()
  }
}

private let padding = Brandbook.Paddings.normal
