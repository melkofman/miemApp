
//
//  ViewController.swift
//  projectDescription
//
//  Created by Ilya on 19.01.2022.
//

import UIKit
import Foundation
import Alamofire

class MoreProjectScreenLoad: UIViewController {
  
  var once = false
  let token: Property<String>
  var count = 0
  
  var controller: UIViewController {
    self
  }
  
  var scrollView = UIScrollView()
  var stackView = UIStackView()
  var idLabel = UILabel()
  var projectName = UILabel()
  var statusLabel = UILabel()
  var mailButton = UIButton()
  var teamLabel = UILabel()
  var infoLabel = UILabel()
  var aimLabel = UILabel()
  var aimTextLabel = UILabel()
  var annotationLabel = UILabel()
  var annotationTextLabel = UILabel()
  var linksLabel = UILabel()
  var linksStackView = UIStackView()
  var vacanciesLabel = UILabel()
  var vacanciesStackView = UIStackView()
  
  var modelHeader: ProjectHeaderModel?
  var modelBody: ProjectBodyModel?
  var modelVacancy: [VacancyInfoModel]?
  var modelTeam: ProjectMemberResponseModel?
  
  
  private let refreshAction: () -> Void
  let id: Int
  
  init(refreshAction: @escaping () -> Void, id: Int, token: Property<String>) {
    self.id = id
    self.refreshAction = refreshAction
    self.token = token
    super.init(nibName: nil, bundle: nil)
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if #available(iOS 13.0, *) {
      view.backgroundColor = Brandbook.Colors.dark_light
    } else {
      // Fallback on earlier versions
    }
    configureScrollView()
    configureIdLabel()
    configureProjectNameLabel()
    configureSatusLabel()
    configureMailButton()
    configureTeamLabel()
    configureStackView()
    configureInfoLabel()
    configureAimLabel()
    configureAimTextLabelLabel()
    configureAnnotationLabel()
    configureAnnotationTextLabelLabel()
    configureLinksLabel()
    configureLinksStackView()
    configureVacanciesLabel()
    configureVacanciesStackView()
    
    scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo:scrollView.widthAnchor).isActive = true
    scrollView.contentLayoutGuide.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
    scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: vacanciesStackView.bottomAnchor).isActive = true
  }
  
  func configureScrollView(){
    
    view.addSubview(scrollView)
    if #available(iOS 13.0, *) {
      scrollView.backgroundColor = Brandbook.Colors.dark_light
    } else {
      // Fallback on earlier versions
    }
    
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    let guide = view.safeAreaLayoutGuide
    scrollView.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0).isActive = true
    guide.bottomAnchor.constraint(equalToSystemSpacingBelow: scrollView.bottomAnchor, multiplier: 1.0).isActive = true
  }
  
  func reloadViews() {
    self.controller.reloadInputViews()
    
    self.configureScrollView()
    self.configureIdLabel()
    self.configureProjectNameLabel()
    self.configureSatusLabel()
    self.configureMailButton()
    self.configureTeamLabel()
    self.configureStackView()
    self.configureInfoLabel()
    self.configureAimLabel()
    self.configureAimTextLabelLabel()
    self.configureAnnotationLabel()
    self.configureAnnotationTextLabelLabel()
    self.configureLinksLabel()
    self.configureLinksStackView()
    self.configureVacanciesLabel()
    self.configureVacanciesStackView()
    once = true
    
  }
  
  func configureIdLabel() {
    scrollView.addSubview(idLabel)
    if #available(iOS 13.0, *) {
      idLabel.backgroundColor = Brandbook.Colors.dark_light
    } else {
      // Fallback on earlier versions
    }
    idLabel.textColor = .darkGray
    idLabel.textAlignment = .left
    idLabel.font = UIFont.systemFont(ofSize: 18)
    idLabel.numberOfLines = 0
    idLabel.text = modelHeader?.number
    
    idLabel.translatesAutoresizingMaskIntoConstraints = false
    idLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    idLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20).isActive = true
    idLabel.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
  }
  
  func configureProjectNameLabel() {
    scrollView.addSubview(projectName)
    if #available(iOS 13.0, *) {
      projectName.backgroundColor = Brandbook.Colors.dark_light
      projectName.textColor = Brandbook.Colors.dark_light_text
    } else {
      // Fallback on earlier versions
      projectName.textColor = .black
    }
    
    projectName.textAlignment = .left
    projectName.font = UIFont.boldSystemFont(ofSize: 20)
    projectName.numberOfLines = 0
    projectName.text = modelHeader?.nameRus
    
    projectName.translatesAutoresizingMaskIntoConstraints = false
    projectName.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    projectName.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20).isActive = true
    projectName.topAnchor.constraint(equalTo: idLabel.bottomAnchor).isActive = true
  }
  
  func configureSatusLabel() {
    scrollView.addSubview(statusLabel)
    if #available(iOS 13.0, *) {
      statusLabel.backgroundColor = Brandbook.Colors.dark_light
      statusLabel.textColor = Brandbook.Colors.dark_light_text
    } else {
      // Fallback on earlier versions
      statusLabel.textColor = .black
    }
    statusLabel.textAlignment = .center
    statusLabel.font = UIFont.boldSystemFont(ofSize: 16)
    statusLabel.numberOfLines = 1
    statusLabel.layer.masksToBounds = true
    statusLabel.layer.cornerRadius = 4
    statusLabel.text = modelHeader?.statusLabel
    decideStatusColor(statusLabel)
    
    statusLabel.translatesAutoresizingMaskIntoConstraints = false
    statusLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10).isActive = true
    statusLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 70).isActive = true
    statusLabel.widthAnchor.constraint(lessThanOrEqualTo: scrollView.widthAnchor, multiplier: 0.5).isActive = true
    statusLabel.topAnchor.constraint(equalTo: projectName.bottomAnchor, constant: 5).isActive = true
  }
  
  private func decideStatusColor(_ label: UILabel) {
    if (label.text == ("Готов к работе")) || (label.text == ("Рабочий")){
      label.backgroundColor = .systemGreen
    }
    if (label.text == ("В архиве")) {
      label.backgroundColor = .systemGray
    }
  }
  
  func configureMailButton() {
    scrollView.addSubview(mailButton)
    if #available(iOS 13.0, *) {
      mailButton.backgroundColor = Brandbook.Colors.dark_light
      mailButton.tintColor = Brandbook.Colors.dark_light_text
    } else {
      // Fallback on earlier versions
      mailButton.tintColor = .black
    }
    mailButton.setTitle(modelHeader?.googleGroup, for: .normal)
    mailButton.setTitleColor(.systemBlue, for: .normal)
    mailButton.contentHorizontalAlignment = .left
    mailButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    mailButton.addTarget(self, action: #selector(didTapMailButton), for: .touchDown)
    
    mailButton.translatesAutoresizingMaskIntoConstraints = false
    mailButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10).isActive = true
    mailButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    mailButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 70).isActive = true
    mailButton.widthAnchor.constraint(lessThanOrEqualTo: scrollView.widthAnchor, multiplier: 0.6).isActive = true
    mailButton.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 5).isActive = true
  }
  
  func configureTeamLabel() {
    scrollView.addSubview(teamLabel)
    if #available(iOS 13.0, *) {
      teamLabel.backgroundColor = Brandbook.Colors.dark_light
      
      teamLabel.textColor = Brandbook.Colors.dark_light_text
    } else {
      // Fallback on earlier versions
      teamLabel.textColor = .black
    }
    teamLabel.textAlignment = .left
    teamLabel.font = UIFont.boldSystemFont(ofSize: 20)
    teamLabel.numberOfLines = 1
    teamLabel.text = "Команда"
    
    teamLabel.translatesAutoresizingMaskIntoConstraints = false
    teamLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    teamLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20).isActive = true
    teamLabel.topAnchor.constraint(equalTo: mailButton.bottomAnchor, constant: 15).isActive = true
  }
  
  private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
  }
  
  func configureStackView(){
    if count == 0 {
      scrollView.addSubview(stackView)
      if #available(iOS 13.0, *) {
        stackView.backgroundColor = Brandbook.Colors.dark_light
      } else {
        // Fallback on earlier versions
        stackView.backgroundColor = .white
      }
      stackView.axis = .vertical
      stackView.distribution = .equalSpacing
      stackView.spacing = 15
      var arrayOfNames = [String]()
      var arrayOfDescriptions = [String]()
      var arrayOfPics = [String]()
      if let model = modelTeam {
        for i in model.leaders {
          arrayOfNames.append(i.first_name + " " + i.last_name)
        }
        for i in model.activeMembers {
          arrayOfNames.append(i.first_name + " " + i.last_name)
        }
        for i in model.leaders {
          arrayOfDescriptions.append(i.role)
        }
        for i in model.activeMembers {
          arrayOfDescriptions.append(i.role)
        }
        for i in model.leaders {
          arrayOfPics.append(i.pic)
        }
        for i in model.activeMembers {
          arrayOfPics.append(i.pic)
        }
        count = 1
      }
      for i in 0..<arrayOfNames.count {
        let stackViewIn = UIStackView()
        stackView.addArrangedSubview(stackViewIn)
        stackViewIn.axis = .horizontal
        stackViewIn.spacing = 10
        
        let url_img = URL(string: arrayOfPics[i])
        if let url = url_img {
          getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { [weak self] in
              
              
              let image = UIImage(data: data)
              let imageView = UIImageView(image: image)
              imageView.contentMode = .scaleAspectFill
              imageView.layer.cornerRadius = 30
              imageView.clipsToBounds = true
              imageView.translatesAutoresizingMaskIntoConstraints = false
              stackViewIn.addArrangedSubview(imageView)
              imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
              imageView.widthAnchor.constraint(equalTo: self?.scrollView.widthAnchor ?? self?.controller.view.widthAnchor as! NSLayoutDimension, multiplier: 0.15).isActive = true
            }
          }
        }
        
        let stackViewInfo = UIStackView()
        stackViewIn.addArrangedSubview(stackViewInfo)
        stackViewInfo.axis = .vertical
        stackViewInfo.distribution = .fillEqually
        stackViewInfo.spacing = 5
        
        let nameOfParticipant = UILabel()
        stackViewInfo.addArrangedSubview(nameOfParticipant)
        nameOfParticipant.text = arrayOfNames[i]
        nameOfParticipant.numberOfLines = 1
        nameOfParticipant.font = .boldSystemFont(ofSize: 16)
        nameOfParticipant.adjustsFontSizeToFitWidth = true
        nameOfParticipant.minimumScaleFactor = 1
        
        
        let descriptionOfParticipant = UILabel()
        stackViewInfo.addArrangedSubview(descriptionOfParticipant)
        descriptionOfParticipant.text = arrayOfDescriptions[i]
        descriptionOfParticipant.numberOfLines = 0
        descriptionOfParticipant.sizeToFit()
        descriptionOfParticipant.lineBreakMode = .byWordWrapping
        descriptionOfParticipant.font = .systemFont(ofSize: 16)
        descriptionOfParticipant.adjustsFontSizeToFitWidth = true
        descriptionOfParticipant.minimumScaleFactor = 1
        
      }
      
      stackView.translatesAutoresizingMaskIntoConstraints = false
      stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
      stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20).isActive = true
      stackView.topAnchor.constraint(equalTo: teamLabel.bottomAnchor, constant: 10).isActive = true
    }
  }
  
  func configureInfoLabel() {
    scrollView.addSubview(infoLabel)
    if #available(iOS 13.0, *) {
      infoLabel.backgroundColor = Brandbook.Colors.dark_light
      infoLabel.textColor = Brandbook.Colors.dark_light_text
    } else {
      // Fallback on earlier versions
      infoLabel.textColor = .black
    }
    
    infoLabel.textAlignment = .left
    infoLabel.font = UIFont.boldSystemFont(ofSize: 20)
    infoLabel.numberOfLines = 1
    infoLabel.text = "Общая информация"
    
    infoLabel.translatesAutoresizingMaskIntoConstraints = false
    infoLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    infoLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20).isActive = true
    infoLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 15).isActive = true
  }
  
  func configureAimLabel() {
    scrollView.addSubview(aimLabel)
    if #available(iOS 13.0, *) {
      aimLabel.backgroundColor = Brandbook.Colors.dark_light
      aimLabel.textColor = Brandbook.Colors.dark_light_text
    } else {
      // Fallback on earlier versions
      aimLabel.textColor = .black
    }
    
    aimLabel.textAlignment = .left
    aimLabel.font = UIFont.boldSystemFont(ofSize: 18)
    aimLabel.numberOfLines = 1
    aimLabel.text = "Цель проекта"
    
    aimLabel.translatesAutoresizingMaskIntoConstraints = false
    aimLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    aimLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20).isActive = true
    aimLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 5).isActive = true
  }
  
  func configureAimTextLabelLabel() {
    scrollView.addSubview(aimTextLabel)
    if #available(iOS 13.0, *) {
      aimTextLabel.backgroundColor = Brandbook.Colors.dark_light
      aimTextLabel.textColor = Brandbook.Colors.dark_light_text
    } else {
      // Fallback on earlier versions
      aimTextLabel.textColor = .black
    }
    
    aimTextLabel.textAlignment = .left
    aimTextLabel.font = UIFont.systemFont(ofSize: 15)
    aimTextLabel.numberOfLines = 0
    aimTextLabel.text = modelBody?.target
    
    aimTextLabel.translatesAutoresizingMaskIntoConstraints = false
    aimTextLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    aimTextLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20).isActive = true
    aimTextLabel.topAnchor.constraint(equalTo: aimLabel.bottomAnchor, constant: 1).isActive = true
  }
  
  func configureAnnotationLabel() {
    scrollView.addSubview(annotationLabel)
    if #available(iOS 13.0, *) {
      annotationLabel.backgroundColor = Brandbook.Colors.dark_light
      annotationLabel.textColor = Brandbook.Colors.dark_light_text
    } else {
      // Fallback on earlier versions
      annotationLabel.textColor = .black
    }
    
    annotationLabel.textAlignment = .left
    annotationLabel.font = UIFont.boldSystemFont(ofSize: 18)
    annotationLabel.numberOfLines = 1
    annotationLabel.text = "Аннотация"
    
    annotationLabel.translatesAutoresizingMaskIntoConstraints = false
    annotationLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    annotationLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20).isActive = true
    annotationLabel.topAnchor.constraint(equalTo: aimTextLabel.bottomAnchor, constant: 5).isActive = true
  }
  
  func configureAnnotationTextLabelLabel() {
    scrollView.addSubview(annotationTextLabel)
    if #available(iOS 13.0, *) {
      annotationTextLabel.backgroundColor = Brandbook.Colors.dark_light
      annotationTextLabel.textColor = Brandbook.Colors.dark_light_text
    } else {
      // Fallback on earlier versions
      annotationTextLabel.textColor = .black
    }
    
    annotationTextLabel.textAlignment = .left
    annotationTextLabel.font = UIFont.systemFont(ofSize: 15)
    annotationTextLabel.numberOfLines = 0
    annotationTextLabel.text = modelBody?.annotation
    
    annotationTextLabel.translatesAutoresizingMaskIntoConstraints = false
    annotationTextLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    annotationTextLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20).isActive = true
    annotationTextLabel.topAnchor.constraint(equalTo: annotationLabel.bottomAnchor, constant: 1).isActive = true
  }
  
  func configureLinksLabel() {
    scrollView.addSubview(linksLabel)
    if #available(iOS 13.0, *) {
      linksLabel.backgroundColor = Brandbook.Colors.dark_light
      linksLabel.textColor = Brandbook.Colors.dark_light_text
    } else {
      // Fallback on earlier versions
      linksLabel.textColor = .black
    }
    
    linksLabel.textAlignment = .left
    linksLabel.font = UIFont.boldSystemFont(ofSize: 20)
    linksLabel.numberOfLines = 1
    linksLabel.text = "Ссылки"
    
    linksLabel.translatesAutoresizingMaskIntoConstraints = false
    linksLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    linksLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20).isActive = true
    linksLabel.topAnchor.constraint(equalTo: annotationTextLabel.bottomAnchor, constant: 15).isActive = true
  }
  
  func configureLinksStackView(){
    scrollView.addSubview(linksStackView)
    if #available(iOS 13.0, *) {
      linksStackView.backgroundColor = Brandbook.Colors.dark_light
    } else {
      // Fallback on earlier versions
    }
    linksStackView.axis = .vertical
    linksStackView.distribution = .equalSpacing
    linksStackView.spacing = 2
    
    let myDict = ["Wiki": modelHeader?.wiki,
                  "Zulip": modelHeader?.chat]
    
    for (name, link) in myDict {
      if link != nil {
        let linkButton = UIButton()
        linksStackView.addArrangedSubview(linkButton)
        linkButton.backgroundColor = .white
        linkButton.setTitle(String(name), for: .normal)
        linkButton.setTitleColor(.systemBlue, for: .normal)
        linkButton.contentHorizontalAlignment = .left
        linkButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        linkButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        linkButton.addTarget(self, action: #selector(didTapLinkButton), for: .touchDown)
      }
    }
    
    linksStackView.translatesAutoresizingMaskIntoConstraints = false
    linksStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10).isActive = true
    linksStackView.widthAnchor.constraint(lessThanOrEqualTo: scrollView.widthAnchor, multiplier: 0.6).isActive = true
    linksStackView.topAnchor.constraint(equalTo: linksLabel.bottomAnchor).isActive = true
  }
  
  func configureVacanciesLabel() {
    scrollView.addSubview(vacanciesLabel)
    if #available(iOS 13.0, *) {
      vacanciesLabel.backgroundColor = Brandbook.Colors.dark_light
      vacanciesLabel.textColor = Brandbook.Colors.dark_light_text
    } else {
      // Fallback on earlier versions
      vacanciesLabel.textColor = .black
    }
    
    vacanciesLabel.textAlignment = .left
    vacanciesLabel.font = UIFont.boldSystemFont(ofSize: 20)
    vacanciesLabel.numberOfLines = 1
    vacanciesLabel.text = "Вакансии"
    
    vacanciesLabel.translatesAutoresizingMaskIntoConstraints = false
    vacanciesLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    vacanciesLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20).isActive = true
    vacanciesLabel.topAnchor.constraint(equalTo: linksStackView.bottomAnchor, constant: 14).isActive = true
  }
  
  func configureVacanciesStackView(){
    if !once {
      scrollView.addSubview(vacanciesStackView)
      if #available(iOS 13.0, *) {
        vacanciesStackView.backgroundColor = Brandbook.Colors.dark_light
      } else {
        // Fallback on earlier versions
      }
      vacanciesStackView.axis = .vertical
      vacanciesStackView.distribution = .equalSpacing
      vacanciesStackView.spacing = 5
      
      var vacancyNames = [String]()
      var countVacancies = [Int]()
      var mandatorySkillsArray = [[String]]()
      var desirableSkillsArray = [[String]]()
      
      if let model = modelVacancy {
        for i in model {
          
          
          vacancyNames.append(i.role)
          countVacancies.append(i.count)
          mandatorySkillsArray.append(i.disciplines)
          desirableSkillsArray.append(i.additionally)
        }
      }
      
      for i in 0..<vacancyNames.count {
        
        let vacancyView = VacancyView(mandatorySkills: mandatorySkillsArray[i], desirableSkills: desirableSkillsArray[i], id: modelVacancy?[i].vacancy_id ?? 0, token: self.token)
        vacanciesStackView.addArrangedSubview(vacancyView)
        vacancyView.clipsToBounds = true
        vacancyView.backgroundColor = .white
        vacancyView.layer.cornerRadius = 10
        vacancyView.layer.borderWidth = 2
        vacancyView.layer.borderColor = UIColor.systemBlue.cgColor
        vacancyView.vacancyNameLabel.text = (vacancyNames[i]) + " - " + String(countVacancies[i])
      }
      
      vacanciesStackView.translatesAutoresizingMaskIntoConstraints = false
      vacanciesStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
      vacanciesStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20).isActive = true
      vacanciesStackView.topAnchor.constraint(equalTo: vacanciesLabel.bottomAnchor, constant: 5).isActive = true
    }
  }
  
  @objc func didTapMailButton(sender: AnyObject) {
    UIButton.animate(withDuration: 0.4) {
      self.mailButton.titleLabel?.alpha = 0.5
      self.mailButton.titleLabel?.alpha = 1
    }
    UIPasteboard.general.string = mailButton.titleLabel?.text
  }
  
  @objc func didTapLinkButton(sender : AnyObject) {
    if let url = URL(string: modelHeader?.chat ?? modelHeader?.wiki ?? ""){
      UIApplication.shared.open(url)
    }
  }
  
  class VacancyView: UIView {
    
    var mandatorySkills = [""]
    var desirableSkills = [""]
    
    var id: Int
    var token: Property<String>?
    
    var vacancyNameLabel: UILabel = {
      let label = UILabel()
      label.backgroundColor = .systemBlue
      label.textColor = .white
      label.textAlignment = .center
      label.font = UIFont.systemFont(ofSize: 18)
      label.numberOfLines = 0
      return label
    }()
    
    var mandatoryLabel: UILabel = {
      let label = UILabel()
      label.text = "Обязательно:"
      label.backgroundColor = .white
      label.textColor = .systemBlue
      label.textAlignment = .left
      label.font = UIFont.systemFont(ofSize: 16)
      label.numberOfLines = 1
      return label
    }()
    
    var desirableLabel: UILabel = {
      let label = UILabel()
      label.text = "Желательно:"
      label.backgroundColor = .white
      label.textColor = .systemBlue
      label.textAlignment = .left
      label.font = UIFont.systemFont(ofSize: 16)
      label.numberOfLines = 1
      return label
    }()
    
    var mandatoryStackView: UIStackView = {
      let stackView = UIStackView()
      stackView.backgroundColor = .white
      stackView.axis = .vertical
      stackView.distribution = .equalSpacing
      stackView.spacing = 3
      return stackView
    }()
    
    var desirableStackView: UIStackView = {
      let stackView = UIStackView()
      stackView.backgroundColor = .white
      stackView.axis = .vertical
      stackView.distribution = .equalSpacing
      stackView.spacing = 3
      return stackView
    }()
    
    let vacancyField: UITextView = {
      let field = UITextView()
      field.backgroundColor = Brandbook.Colors.system_gray3
      field.translatesAutoresizingMaskIntoConstraints = false
      field.layer.cornerRadius = 10
      field.textColor = .black
      field.sizeToFit()
      field.font = UIFont.systemFont(ofSize: 16)
      
      return field
    }()
    
    var cancelButton: UIButton = {
      let button = UIButton()
      button.backgroundColor = .systemGray
      button.layer.cornerRadius = 10
      button.setTitle("Отмена", for: .normal)
      button.setTitleColor(.white, for: .normal)
      button.contentHorizontalAlignment = .center
      button.addTarget(self, action: #selector(didTapCancelButton), for: .touchDown)
      return button
    }()
    
    var applyButton: UIButton = {
      let button = UIButton()
      button.backgroundColor = .systemBlue
      button.layer.cornerRadius = 10
      button.setTitle("Записаться", for: .normal)
      button.setTitleColor(.white, for: .normal)
      button.contentHorizontalAlignment = .center
      button.addTarget(self, action: #selector(didTapApplyButton), for: .touchDown)
      return button
    }()
    
    required init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    init(mandatorySkills: [String], desirableSkills: [String], id: Int, token: Property<String>) {
      self.id = id
      super.init(frame: CGRect.zero)
      self.mandatorySkills = mandatorySkills
      self.desirableSkills = desirableSkills
      self.token = token
      configureViews()
      configureConstraints()
    }
    
    func configureViews() {
      self.addSubview(vacancyNameLabel)
      self.addSubview(mandatoryLabel)
      self.addSubview(mandatoryStackView)
      self.addSubview(desirableLabel)
      self.addSubview(desirableStackView)
      self.addSubview(vacancyField)
      self.addSubview(applyButton)
      self.addSubview(cancelButton)
      
    }
    
    func configureConstraints() {
      self.translatesAutoresizingMaskIntoConstraints = false
      configureVacancyNameLabel()
      configureMandatoryLabel()
      configureMandatoryStackView()
      configureDesirableLabel()
      configureDesirableStackView()
      configureVacancyTextField()
      configureApplyButton()
      configureCancelButton()
      
      
    }
    
    func configureVacancyNameLabel() {
      vacancyNameLabel.translatesAutoresizingMaskIntoConstraints = false
      vacancyNameLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
      vacancyNameLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
      vacancyNameLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2).isActive = true
    }
    
    func configureMandatoryLabel() {
      mandatoryLabel.translatesAutoresizingMaskIntoConstraints = false
      mandatoryLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
      mandatoryLabel.topAnchor.constraint(equalTo: vacancyNameLabel.bottomAnchor, constant: 15).isActive = true
      mandatoryLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -10).isActive = true
    }
    
    func configureMandatoryStackView() {
      for mandatorySkill in mandatorySkills {
        let mandatorySkillLabel = UILabel()
        mandatoryStackView.addArrangedSubview(mandatorySkillLabel)
        mandatorySkillLabel.backgroundColor = .white
        mandatorySkillLabel.numberOfLines = 0
        mandatorySkillLabel.text = "-\(mandatorySkill)"
        mandatorySkillLabel.textColor = .black
        mandatorySkillLabel.textAlignment = .left
        mandatorySkillLabel.font = UIFont.boldSystemFont(ofSize: 14)
      }
      
      mandatoryStackView.translatesAutoresizingMaskIntoConstraints = false
      mandatoryStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
      mandatoryStackView.topAnchor.constraint(equalTo: mandatoryLabel.bottomAnchor, constant: 5).isActive = true
      mandatoryStackView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -10).isActive = true
    }
    
    func configureDesirableLabel() {
      desirableLabel.translatesAutoresizingMaskIntoConstraints = false
      desirableLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
      desirableLabel.topAnchor.constraint(equalTo: mandatoryStackView.bottomAnchor, constant: 5).isActive = true
      desirableLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -10).isActive = true
    }
    
    func configureDesirableStackView() {
      for desirableSkill in desirableSkills {
        let desirableSkillLabel = UILabel()
        desirableStackView.addArrangedSubview(desirableSkillLabel)
        desirableSkillLabel.backgroundColor = .white
        desirableSkillLabel.numberOfLines = 0
        desirableSkillLabel.text = "-\(desirableSkill)"
        desirableSkillLabel.textColor = .black
        desirableSkillLabel.textAlignment = .left
        desirableSkillLabel.font = UIFont.boldSystemFont(ofSize: 14)
      }
      
      desirableStackView.translatesAutoresizingMaskIntoConstraints = false
      desirableStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
      desirableStackView.topAnchor.constraint(equalTo: desirableLabel.bottomAnchor, constant: 5).isActive = true
      desirableStackView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -10).isActive = true
    }
    
    func configureVacancyTextField() {
      vacancyField.translatesAutoresizingMaskIntoConstraints = false
      vacancyField.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
      vacancyField.topAnchor.constraint(equalTo: desirableStackView.bottomAnchor, constant: 15).isActive = true
      vacancyField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Brandbook.Paddings.normal).isActive = true
      vacancyField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -Brandbook.Paddings.normal).isActive = true
      vacancyField.heightAnchor.constraint(equalToConstant: 170).isActive = true
      
    }
    
    func configureApplyButton() {
      applyButton.translatesAutoresizingMaskIntoConstraints = false
      applyButton.topAnchor.constraint(equalTo: vacancyField.bottomAnchor, constant: 15).isActive = true
      applyButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Brandbook.Paddings.normal).isActive = true
      applyButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4).isActive = true
      applyButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
      
    }
    
    func configureCancelButton() {
      cancelButton.translatesAutoresizingMaskIntoConstraints = false
      cancelButton.topAnchor.constraint(equalTo: vacancyField.bottomAnchor, constant: 15).isActive = true
      cancelButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -Brandbook.Paddings.normal).isActive = true
      cancelButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4).isActive = true
      cancelButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
      
    }
    
    @objc func didTapApplyButton() {
      let text = vacancyField.text
      var message = "Заявка успешно создана"
      let vacancy_id = self.id
      if let token = self.token?.value {
        
        let parameters: [String: Any] = ["about_me": text, "vacancy_id": vacancy_id]
        let url = URL(string: "https://devcabinet.miem.vmnet.top/api/student/application/add")!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue(token, forHTTPHeaderField: "x-auth-token")
        do {
          
          request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
          message = error.localizedDescription
          print(error.localizedDescription)
          return
        }
        
        let task = session.dataTask(with: request) { [self] data, response, error in
          
          if let error = error {
            message = "Ошибка запроса: \(error.localizedDescription)"
            print(error.localizedDescription)
            return
          }
          
          
          guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
                  
          else {
            message = "Получен неверный ответ сервера"
            return
          }
          guard let responseData = data else {
            message = "Получен неверный ответ сервера"
            return
          }
          
          do {
            if let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [String: Any] {
              print(jsonResponse)
              message = "Заявка успешно создана"
            } else {
              message = "Неверный формат данных"
              throw URLError(.badServerResponse)
            }
          } catch let error {
            message = "\(error.localizedDescription)"
            print(error.localizedDescription)
          }
        }
        task.resume()
        alert(message: message)
      }
      
    }
    
    private func alert(message: String) {
      let alert = UIAlertView()
      alert.message = message
      alert.addButton(withTitle: "ОК")
      alert.show()
    }
    
    
    
    @objc func didTapCancelButton() {
      vacancyField.text = nil
    }
  }
}
