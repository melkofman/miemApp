//
//  SwipeCardView.swift
//  TinderStack
//
//  Created by Ilya on 11.11.2021.
//

import UIKit

class SwipeCardView: UIView {
  
  //MARK: - Properties
  var swipeView: UIView!
  var shadowView: UIView!
  var backgroundL: UIView!
  var darkBackground: UIView!
  
  var thumbImage = UIImageView()
  var idLabel = UILabel()
  var nameRusLabel = UILabel()
  var vacanciesLabel = UILabel()
  var lineLabel = UILabel()
  var requirementsStackView = UIStackView()
  
  var delegate: SwipeCardsDelegate?
  
  var count = 0
  var divisor: CGFloat = 0
  let baseView = UIView()
  
  var dataSource: CardDataModel? {
    didSet {
      
      idLabel.text = "#\(dataSource?.project_id ?? 0)"
      
      vacanciesLabel.text = "Вакансия:\n\n\(dataSource?.vacancy_role ?? "Вакансия не найдена")"
      
      for requirement in dataSource?.vacancy_disciplines ?? [] {
        count += 1
        if count > 3 {
          break
        }
        let requirementLabel = UILabel()
        requirementLabel.text = "\(requirement)"
        requirementLabel.backgroundColor = .white
        requirementLabel.textColor = .systemBlue
        requirementLabel.layer.cornerRadius = 10
        requirementLabel.layer.borderColor = UIColor.systemBlue.cgColor
        requirementLabel.layer.borderWidth = 2.0
        requirementLabel.textAlignment = .center
        requirementLabel.font = UIFont.systemFont(ofSize: 18)
        requirementLabel.numberOfLines = 0
        requirementLabel.adjustsFontSizeToFitWidth = true
        requirementsStackView.addArrangedSubview(requirementLabel)
        
      }
      
      nameRusLabel.text = dataSource?.project_name_rus
      
    }
  }
  
  //MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: .zero)
    configureShadowView()
    configureSwipeView()
    configureBackgroundL()
    configureIdLabelView()
    configureNameRusLabelView()
    configureVacanciesLabelView()
    configureRequirementsStackView()
    configureLineLabelView()
    configureDarkBackground()
    configureThumbImageView()
    addPanGestureOnCards()
    configureTapGesture()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: - Configuration
  
  func configureShadowView() {
    shadowView = UIView()
    shadowView.backgroundColor = .clear
    shadowView.layer.shadowColor = UIColor.black.cgColor
    shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
    shadowView.layer.cornerRadius = 10
    shadowView.layer.shadowOpacity = 0.8
    shadowView.layer.shadowRadius = 12.0
    addSubview(shadowView)
    
    shadowView.translatesAutoresizingMaskIntoConstraints = false
    shadowView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    shadowView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    shadowView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    shadowView.topAnchor.constraint(equalTo: topAnchor).isActive = true
  }
  
  func configureSwipeView() {
    swipeView = UIView()
    swipeView.layer.cornerRadius = 10
    swipeView.clipsToBounds = true
    shadowView.addSubview(swipeView)
    
    swipeView.translatesAutoresizingMaskIntoConstraints = false
    swipeView.leftAnchor.constraint(equalTo: shadowView.leftAnchor).isActive = true
    swipeView.rightAnchor.constraint(equalTo: shadowView.rightAnchor).isActive = true
    swipeView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor).isActive = true
    swipeView.topAnchor.constraint(equalTo: shadowView.topAnchor).isActive = true
  }
  
  func configureBackgroundL() {
    backgroundL = UIView()
    backgroundL.backgroundColor = .white
    swipeView.addSubview(backgroundL)
    
    backgroundL.translatesAutoresizingMaskIntoConstraints = false
    backgroundL.leftAnchor.constraint(equalTo: swipeView.leftAnchor).isActive = true
    backgroundL.rightAnchor.constraint(equalTo: swipeView.rightAnchor).isActive = true
    backgroundL.topAnchor.constraint(equalTo: swipeView.topAnchor).isActive = true
    backgroundL.bottomAnchor.constraint(equalTo: swipeView.bottomAnchor).isActive = true
  }
  
  func configureIdLabelView() {
    backgroundL.addSubview(idLabel)
    idLabel.backgroundColor = .white
    idLabel.textColor = .darkGray
    idLabel.textAlignment = .left
    idLabel.font = UIFont.systemFont(ofSize: 18)
    idLabel.numberOfLines = 0
    
    idLabel.translatesAutoresizingMaskIntoConstraints = false
    idLabel.centerXAnchor.constraint(equalTo: backgroundL.centerXAnchor).isActive = true
    idLabel.widthAnchor.constraint(equalTo: backgroundL.widthAnchor, constant: -10).isActive = true
    idLabel.topAnchor.constraint(equalTo: backgroundL.topAnchor).isActive = true
    idLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    
  }
  
  func configureNameRusLabelView() {
    backgroundL.addSubview(nameRusLabel)
    nameRusLabel.backgroundColor = .white
    nameRusLabel.textColor = .black
    nameRusLabel.layer.cornerRadius = 10
    nameRusLabel.layer.borderColor = UIColor.systemGreen.cgColor
    nameRusLabel.layer.borderWidth = 2.0
    nameRusLabel.textAlignment = .center
    nameRusLabel.font = UIFont.boldSystemFont(ofSize: 20)
    nameRusLabel.adjustsFontSizeToFitWidth = true
    nameRusLabel.numberOfLines = 0
    
    nameRusLabel.translatesAutoresizingMaskIntoConstraints = false
    nameRusLabel.centerXAnchor.constraint(equalTo: backgroundL.centerXAnchor).isActive = true
    nameRusLabel.widthAnchor.constraint(equalTo: backgroundL.widthAnchor, constant: -10).isActive = true
    nameRusLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor).isActive = true
    nameRusLabel.heightAnchor.constraint(equalToConstant: 85).isActive = true
    
  }
  
  func configureVacanciesLabelView() {
    backgroundL.addSubview(vacanciesLabel)
    vacanciesLabel.backgroundColor = .white
    vacanciesLabel.textColor = .black
    vacanciesLabel.textAlignment = .left
    vacanciesLabel.font = UIFont.systemFont(ofSize: 20)
    vacanciesLabel.numberOfLines = 0
    
    vacanciesLabel.translatesAutoresizingMaskIntoConstraints = false
    vacanciesLabel.centerXAnchor.constraint(equalTo: backgroundL.centerXAnchor).isActive = true
    vacanciesLabel.widthAnchor.constraint(equalTo: backgroundL.widthAnchor, constant: -10).isActive = true
    vacanciesLabel.topAnchor.constraint(equalTo: nameRusLabel.bottomAnchor).isActive = true
    vacanciesLabel.heightAnchor.constraint(equalToConstant: 175).isActive = true
    
  }
  
  func configureRequirementsStackView() {
    backgroundL.addSubview(requirementsStackView)
    requirementsStackView.axis = .vertical
    requirementsStackView.distribution = .fillEqually
    requirementsStackView.alignment = .fill
    requirementsStackView.spacing = 5
    
    requirementsStackView.translatesAutoresizingMaskIntoConstraints = false
    requirementsStackView.centerXAnchor.constraint(equalTo: backgroundL.centerXAnchor).isActive = true
    requirementsStackView.widthAnchor.constraint(equalTo: backgroundL.widthAnchor, constant: -10).isActive = true
    requirementsStackView.topAnchor.constraint(equalTo: vacanciesLabel.bottomAnchor).isActive = true
    requirementsStackView.heightAnchor.constraint(equalToConstant: 80).isActive = true
  }
  
  func configureLineLabelView() {
    backgroundL.addSubview(lineLabel)
    lineLabel.text = ""
    lineLabel.backgroundColor = .white
    
    lineLabel.translatesAutoresizingMaskIntoConstraints = false
    lineLabel.leftAnchor.constraint(equalTo: backgroundL.leftAnchor).isActive = true
    lineLabel.rightAnchor.constraint(equalTo: backgroundL.rightAnchor).isActive = true
    lineLabel.topAnchor.constraint(equalTo: requirementsStackView.bottomAnchor).isActive = true
    lineLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    
  }
  
  func configureDarkBackground() {
    darkBackground = UIView()
    darkBackground.backgroundColor = .black
    darkBackground.alpha = 0
    backgroundL.addSubview(darkBackground)
    
    darkBackground.translatesAutoresizingMaskIntoConstraints = false
    darkBackground.leftAnchor.constraint(equalTo: swipeView.leftAnchor).isActive = true
    darkBackground.rightAnchor.constraint(equalTo: swipeView.rightAnchor).isActive = true
    darkBackground.topAnchor.constraint(equalTo: swipeView.topAnchor).isActive = true
    darkBackground.bottomAnchor.constraint(equalTo: swipeView.bottomAnchor).isActive = true
  }
  
  func configureThumbImageView() {
    backgroundL.addSubview(thumbImage)
    
    thumbImage.translatesAutoresizingMaskIntoConstraints = false
    thumbImage.centerXAnchor.constraint(equalTo: backgroundL.centerXAnchor).isActive = true
    thumbImage.centerYAnchor.constraint(equalTo: backgroundL.centerYAnchor).isActive = true
    thumbImage.widthAnchor.constraint(equalToConstant: 130).isActive = true
    thumbImage.heightAnchor.constraint(equalToConstant: 130).isActive = true
    
  }
  
  func configureTapGesture() {
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture)))
  }
  
  func addPanGestureOnCards() {
    self.isUserInteractionEnabled = true
    addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
  }
  
  //MARK: - Handlers
  @objc func handlePanGesture(sender: UIPanGestureRecognizer){
    let card = sender.view as! SwipeCardView
    let point = sender.translation(in: self)
    let centerOfParentContainer = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
    card.center = CGPoint(x: centerOfParentContainer.x + point.x, y: centerOfParentContainer.y + point.y)
    
    
    if (card.center.x) > (centerOfParentContainer.x + 75) {
      darkBackground.alpha = 0.15
      thumbImage.image = UIImage(named: "thumbUp.png")
      thumbImage.tintColor = .systemGreen
    }else if card.center.x < (centerOfParentContainer.x - 75) {
      darkBackground.alpha = 0.15
      thumbImage.image = UIImage(named: "thumbDown.png")
      thumbImage.tintColor = .systemRed
    }else {
      darkBackground.alpha = 0
      thumbImage.image = nil
    }
    
    switch sender.state {
    case .ended:
      if (card.center.x) > (centerOfParentContainer.x + 75) {
        delegate?.swipeDidEnd(on: card, isLiked: true)
      }else if (card.center.x) < (centerOfParentContainer.x - 75) {
        delegate?.swipeDidEnd(on: card, isLiked: false)
      }else {
        UIView.animate(withDuration: 0.2) {
          card.transform = .identity
          card.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
          self.layoutIfNeeded()
        }
      }
    case .changed:
      let rotation = tan(point.x / (self.frame.width * 2.0))
      card.transform = CGAffineTransform(rotationAngle: rotation)
      
    default:
      break
    }
  }
  
  @objc func handleTapGesture(sender: UITapGestureRecognizer){
  }
}
