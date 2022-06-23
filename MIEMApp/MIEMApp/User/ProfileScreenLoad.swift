//
//  ProfileScreenLoad.swift
//  MIEMApp
//
//  Created by Melanie Kofman on 18.02.2021.
//

import UIKit
import EzPopup
class ProfileScreenLoad: UIViewController, ScreenPayload, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  
  var controller: UIViewController {
    return self
  }
  private let refreshAction: () -> Void
  private let refreshActionAwards: () -> Void
  var modelProject: [ProjectItemModel]? {
    didSet {
      guard !scrollView.isDragging else {
        return
      }
      endRefresh()
    }
  }
  var modelProfile: [ProfileParsedModel]? {
    didSet {
      guard !scrollView.isDragging else {
        return
      }
      endRefresh()
    }
  }
  var modelApplication: [ApplicationParsedModel]? {
    didSet {
      guard !scrollView.isDragging else {
        return
      }
      endRefresh()
    }
  }
  var modelProjectStaff: [StaffParsedProjectsModel]? {
    didSet {
      guard !scrollView.isDragging else {
        return
      }
      endRefresh()
    }
  }
  
  var modelGitStat : GitStat?
  var modelAwards : AwardsModel?
  
  
  private let bottomInset: Variable<CGFloat>
  
  weak var delegate: ProfileScreenLoad?
  init(bottomInset: Variable<CGFloat>, refreshAction: @escaping () -> Void,
       refreshActionAwards: @escaping () -> Void
  ) {
    self.bottomInset = bottomInset
    self.refreshAction = refreshAction
    self.refreshActionAwards = refreshActionAwards
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    scrollView.refreshControl = refreshControl
    setupProfileComponents()
    self.delegate = self
  }
  
  var projectInfo = true
  var applicationInfo = true
  var awardsInfo = true
  let scrollView = UIScrollView()
  let stackView = UIStackView()
  var collectionViewGit: UICollectionView?
  var collectionViewAwards: UICollectionView?
  let activityViewAwards = UIActivityIndicatorView(style: .whiteLarge)
  let activityViewGit = UIActivityIndicatorView(style: .whiteLarge)
  
  
  let containerView: UIView = {
    let view = UIView()
    if #available(iOS 13.0, *) {
      view.backgroundColor = Brandbook.Colors.dark_light
    } else {
      // Fallback on earlier versions
      view.backgroundColor = .white
      
    }
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let containerViewProj: UIView = {
    let view = UIView()
    if #available(iOS 13.0, *) {
      view.backgroundColor = Brandbook.Colors.dark_light
    } else {
      // Fallback on earlier versions
      view.backgroundColor = .white
    }
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let containerViewAppl: UIView = {
    let view = UIView()
    if #available(iOS 13.0, *) {
      view.backgroundColor = Brandbook.Colors.dark_light
    } else {
      // Fallback on earlier versions
    }
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let containerViewGit: UIView = {
    let view = UIView()
    if #available(iOS 13.0, *) {
      view.backgroundColor = Brandbook.Colors.dark_light
    } else {
      // Fallback on earlier versions
    }
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let containerViewAwards: UIView = {
    let view = UIView()
    if #available(iOS 13.0, *) {
      view.backgroundColor = Brandbook.Colors.dark_light
    } else {
      // Fallback on earlier versions
    }
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = .clear
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 70
    imageView.clipsToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  let profileStatus: UILabel = {
    let label = UILabel()
    label.backgroundColor = Brandbook.Colors.greenStatus
    label.clipsToBounds = true
    label.layer.cornerRadius = 6
    label.textAlignment = NSTextAlignment.center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let nameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 20)
    label.textAlignment = NSTextAlignment.center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let surnameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 20)
    label.textAlignment = NSTextAlignment.center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let chatButton: UIButton = {
    let button = UIButton(type: .system)
    button.addTarget(self, action: #selector(chatHandled), for: .touchUpInside)
    button.tintColor = .black
    button.backgroundColor = Brandbook.Colors.greenStatus
    button.clipsToBounds = true
    button.layer.cornerRadius = 6
    button.setTitle("Чат", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  let emailIcon: UIImageView = {
    let imageView = UIImageView()
    imageView.image = Brandbook.Images.Icons.emailIcon
    imageView.contentMode = .scaleAspectFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  let departIcon: UIImageView = {
    let imageView = UIImageView()
    imageView.image = Brandbook.Images.Icons.departIcon
    imageView.contentMode = .scaleAspectFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  let emailLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.sizeToFit()
    label.lineBreakMode = .byWordWrapping
    label.textAlignment = NSTextAlignment.center
    label.textColor = Brandbook.Colors.blueStatus
    label.textAlignment = NSTextAlignment.center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let departLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.sizeToFit()
    label.lineBreakMode = .byWordWrapping
    label.textAlignment = NSTextAlignment.center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let projLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.font = UIFont.boldSystemFont(ofSize: 18)
    label.textAlignment = NSTextAlignment.left
    label.text = "Проекты"
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private var projectView = ProjectsCollectionView()
  
  let applLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.font = UIFont.boldSystemFont(ofSize: 18)
    label.textAlignment = NSTextAlignment.left
    label.text = "Заявки"
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private var applView = ApplicationCollectionView()
  
  let labelNoInfoProject: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.sizeToFit()
    label.lineBreakMode = .byWordWrapping
    label.text = "Нет информации."
    label.textColor = .lightGray
    label.textAlignment = NSTextAlignment.left
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let labelNoInfoApplication: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.sizeToFit()
    label.lineBreakMode = .byWordWrapping
    label.text = "Нет информации."
    label.textColor = .lightGray
    label.textAlignment = NSTextAlignment.left
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let labelGitStat: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.font = UIFont.boldSystemFont(ofSize: 18)
    label.textAlignment = NSTextAlignment.left
    label.text = "Статистика Git"
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let labelAwards: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.font = UIFont.boldSystemFont(ofSize: 18)
    label.textAlignment = NSTextAlignment.left
    label.text = "Достижения"
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let labelNoInfoAwards: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.sizeToFit()
    label.lineBreakMode = .byWordWrapping
    label.text = "Нет информации."
    label.textColor = .lightGray
    label.textAlignment = NSTextAlignment.left
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private func setUpScrollView() {
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(scrollView)
    scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
    scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -bottomInset.value).isActive = true
    scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
    scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
    scrollView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height*10).isActive = true
  }
  
  private func setUpStackView() {
    scrollView.addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
    stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
    stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
    stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    stackView.axis = .vertical
    if #available(iOS 13.0, *) {
      stackView.backgroundColor = Brandbook.Colors.dark_light
    } else {
      // Fallback on earlier versions
    }
  }
  
  private func setUpContainerView() {
    stackView.addArrangedSubview(containerView)
    containerView.translatesAutoresizingMaskIntoConstraints = false
    containerView.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
    containerView.leftAnchor.constraint(equalTo: stackView.leftAnchor).isActive = true
    containerView.rightAnchor.constraint(equalTo: stackView.rightAnchor).isActive = true
  }
  
  private func setUpProfileImageView() {
    containerView.addSubview(profileImageView)
    profileImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding).isActive = true
    profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: padding).isActive = true
    profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
  }
  
  private func setUpInsideContainerView() {
    containerView.addSubview(profileStatus)
    profileStatus.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding).isActive = true
    profileStatus.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 0.7*padding).isActive = true
    profileStatus.widthAnchor.constraint(equalToConstant: 140).isActive = true
    profileStatus.heightAnchor.constraint(equalToConstant: ProfileScreenLoad.height(text: profileStatus.text, font: profileStatus.font, width:  profileStatus.frame.width).height + padding).isActive = true
    
    containerView.addSubview(nameLabel)
    nameLabel.topAnchor.constraint(equalTo: profileStatus.bottomAnchor, constant: padding/2).isActive = true
    nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 2*padding).isActive = true
    
    containerView.addSubview(surnameLabel)
    surnameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: padding/2).isActive = true
    surnameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 2*padding).isActive = true
    
    containerView.addSubview(chatButton)
    chatButton.topAnchor.constraint(equalTo: surnameLabel.bottomAnchor, constant: padding/2).isActive = true
    chatButton.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 0.7*padding).isActive = true
    chatButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    chatButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
    
    containerView.addSubview(emailIcon)
    emailIcon.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: padding).isActive = true
    emailIcon.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: padding).isActive = true
    emailIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
    emailIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
    
    containerView.addSubview(departIcon)
    departIcon.topAnchor.constraint(equalTo: emailIcon.bottomAnchor, constant: padding).isActive = true
    departIcon.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: padding).isActive = true
    departIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
    departIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
    
    containerView.addSubview(emailLabel)
    emailLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: padding).isActive = true
    emailLabel.leftAnchor.constraint(equalTo: emailIcon.rightAnchor).isActive = true
    emailLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
    containerView.addSubview(departLabel)
    departLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: padding).isActive = true
    departLabel.leftAnchor.constraint(equalTo: departIcon.rightAnchor).isActive = true
    departLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    departLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    
  }
  
  private func setUpAwardsContainer() {
    stackView.addArrangedSubview(containerViewAwards)
    containerViewAwards.translatesAutoresizingMaskIntoConstraints = false
    containerViewAwards.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: padding).isActive = true
    containerViewAwards.leftAnchor.constraint(equalTo: stackView.leftAnchor).isActive = true
    containerViewAwards.rightAnchor.constraint(equalTo: stackView.rightAnchor).isActive = true
    containerViewAwards.heightAnchor.constraint(equalToConstant: Brandbook.Heights.awardCell + 50).isActive = true
  }
  
  private func setUpAwardsLabel() {
    containerViewAwards.addSubview(labelAwards)
    labelAwards.topAnchor.constraint(equalTo: containerViewAwards.topAnchor, constant: padding).isActive = true
    labelAwards.leftAnchor.constraint(equalTo: containerViewAwards.leftAnchor, constant: padding).isActive = true
    
  }
  
  private func setUpCollectionAwards() {
    setUpCollectionViewAwards()
  }
  
  private func setUpCollectionViewAwards() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    
    collectionViewAwards = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionViewAwards?.delegate = self
    collectionViewAwards?.dataSource = self
    collectionViewAwards?.register(AwardCell.self, forCellWithReuseIdentifier: AwardCell.reusedId)
    collectionViewAwards?.translatesAutoresizingMaskIntoConstraints = false
    if #available(iOS 13.0, *) {
      collectionViewAwards?.backgroundColor = Brandbook.Colors.dark_light
    } else {
      // Fallback on earlier versions
    }
    
    containerViewAwards.addSubview(collectionViewAwards!)
    collectionViewAwards?.topAnchor.constraint(equalTo: labelAwards.bottomAnchor).isActive = true
    collectionViewAwards?.leftAnchor.constraint(equalTo: containerViewAwards.leftAnchor, constant: padding).isActive = true
    collectionViewAwards?.rightAnchor.constraint(equalTo: containerViewAwards.rightAnchor).isActive = true
    collectionViewAwards?.bottomAnchor.constraint(equalTo: containerViewAwards.bottomAnchor).isActive = true
    collectionViewAwards?.addSubview(activityViewAwards)
    activityViewAwards.hidesWhenStopped = true
    activityViewAwards.color = .gray
    activityViewAwards.translatesAutoresizingMaskIntoConstraints = false
    activityViewAwards.centerXAnchor.constraint(equalTo: collectionViewAwards!.centerXAnchor).isActive = true
    activityViewAwards.centerYAnchor.constraint(equalTo: collectionViewAwards!.centerYAnchor).isActive = true
    activityViewAwards.startAnimating()
    //    !!!!!
    
  }
  
  func endRefreshAwards() {
    self.activityViewAwards.stopAnimating()
  }
  
  func endRefreshGit() {
    self.activityViewGit.stopAnimating()
  }
  
  
  private func checkAwardsModel() {
    if (modelAwards == nil) || (modelAwards?.data.isEmpty ?? false) {
      awardsInfo = false
    }
    else {
      awardsInfo = true
    }
  }
  
  private func setUpNoAwardsLabel() {
    containerViewAwards.addSubview(labelNoInfoAwards)
    labelNoInfoAwards.topAnchor.constraint(equalTo: labelAwards.bottomAnchor, constant: padding).isActive = true
    labelNoInfoAwards.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: padding).isActive = true
    labelNoInfoAwards.widthAnchor.constraint(equalToConstant: measureFrameForText(labelNoInfoAwards.text!).width + padding).isActive = true
    labelNoInfoAwards.heightAnchor.constraint(equalToConstant: ProfileScreenLoad.height(text: labelNoInfoAwards.text, font: labelNoInfoAwards.font, width:  labelNoInfoAwards.frame.width).height).isActive = true
    //    labelNoInfoAwards.bottomAnchor.constraint(equalTo: containerViewAwards.bottomAnchor).isActive = true
    
  }
  
  private func setUpProjContainer() {
    stackView.addArrangedSubview(containerViewProj)
    containerViewProj.translatesAutoresizingMaskIntoConstraints = false
    containerViewProj.topAnchor.constraint(equalTo: containerViewAwards.bottomAnchor, constant: padding).isActive = true
    containerViewProj.leftAnchor.constraint(equalTo: stackView.leftAnchor).isActive = true
    containerViewProj.rightAnchor.constraint(equalTo: stackView.rightAnchor).isActive = true
  }
  
  private func setUpApplContainer() {
    stackView.addArrangedSubview(containerViewAppl)
    containerViewAppl.translatesAutoresizingMaskIntoConstraints = false
    containerViewAppl.topAnchor.constraint(equalTo: containerViewProj.bottomAnchor, constant: padding).isActive = true
    containerViewAppl.leftAnchor.constraint(equalTo: stackView.leftAnchor).isActive = true
    containerViewAppl.rightAnchor.constraint(equalTo: stackView.rightAnchor).isActive = true
  }
  
  private func setUpProjLabel() {
    containerViewProj.addSubview(projLabel)
    projLabel.topAnchor.constraint(equalTo: containerViewProj.topAnchor, constant: padding).isActive = true
    projLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: padding).isActive = true
    projLabel.widthAnchor.constraint(equalToConstant: measureFrameForText(projLabel.text ?? "").width + padding).isActive = true
    projLabel.heightAnchor.constraint(equalToConstant: ProfileScreenLoad.height(text: projLabel.text, font: projLabel.font, width:  projLabel.frame.width).height).isActive = true
    projLabel.backgroundColor = .clear
  }
  
  private func setUpApplLabel() {
    containerViewAppl.addSubview(applLabel)
    applLabel.topAnchor.constraint(equalTo: containerViewAppl.topAnchor, constant: padding).isActive = true
    applLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: padding).isActive = true
    applLabel.widthAnchor.constraint(equalToConstant: measureFrameForText(applLabel.text ?? "").width + padding).isActive = true
    applLabel.heightAnchor.constraint(equalToConstant: ProfileScreenLoad.height(text: applLabel.text, font: applLabel.font, width:  applLabel.frame.width).height).isActive = true
    applLabel.backgroundColor = .clear
  }
  
  private func checkProjModel() {
    if (modelProject == nil) || (modelProject?.isEmpty ?? false) {
      projectInfo = false
    }
    else {
      projectInfo = true
    }
  }
  
  private func checkProjAppl() {
    if (modelApplication?[0].data == nil) || (modelApplication?[0].data.isEmpty ?? false) {
      applicationInfo = false
    }
    else {
      applicationInfo = true
    }
  }
  
  
  private func setUpProjects() {
    if projectInfo {
      setProjectView()
    }
    else {
      setNoProjectInfoLabel()
    }
  }
  
  private func setUpApplications() {
    if applicationInfo {
      setApplView()
    }
    else {
      setNoApplLabel()
    }
  }
  
  private func setNoProjectInfoLabel() {
    containerViewProj.addSubview(labelNoInfoProject)
    labelNoInfoProject.topAnchor.constraint(equalTo: projLabel.bottomAnchor, constant: padding).isActive = true
    labelNoInfoProject.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: padding).isActive = true
    labelNoInfoProject.widthAnchor.constraint(equalToConstant: measureFrameForText(labelNoInfoProject.text!).width + padding).isActive = true
    labelNoInfoProject.heightAnchor.constraint(equalToConstant: ProfileScreenLoad.height(text: labelNoInfoProject.text, font: labelNoInfoProject.font, width:  labelNoInfoProject.frame.width).height).isActive = true
    labelNoInfoProject.bottomAnchor.constraint(equalTo: containerViewProj.bottomAnchor).isActive = true
  }
  
  private func setProjectView() {
    containerViewProj.addSubview(projectView)
    projectView.translatesAutoresizingMaskIntoConstraints = false
    projectView.topAnchor.constraint(equalTo: projLabel.bottomAnchor, constant: small).isActive = true
    projectView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: padding).isActive = true
    projectView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
    projectView.heightAnchor.constraint(equalToConstant: 350).isActive = true
    projectView.set(cells: ProjectItemModel.fetchProjects(projectsModel: modelProject!))
    projectView.bottomAnchor.constraint(equalTo: containerViewProj.bottomAnchor).isActive = true
    
    stackView.setCustomSpacing(50, after: projectView)
  }
  
  private func setApplView() {
    
    containerViewAppl.addSubview(applView)
    applView.translatesAutoresizingMaskIntoConstraints = false
    applView.topAnchor.constraint(equalTo: applLabel.bottomAnchor, constant: small).isActive = true
    applView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: padding).isActive = true
    applView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    applView.heightAnchor.constraint(equalToConstant: 350).isActive = true
    applView.bottomAnchor.constraint(equalTo: containerViewAppl.bottomAnchor).isActive = true
    applView.setParent(parent: self)
    applView.set(cells: ApplicationItemModel.fetchProjects(modelApplication: modelApplication!))
  }
  
  private func setNoApplLabel() {
    containerViewAppl.addSubview(labelNoInfoApplication)
    labelNoInfoApplication.topAnchor.constraint(equalTo: applLabel.bottomAnchor, constant: padding).isActive = true
    labelNoInfoApplication.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: padding).isActive = true
    labelNoInfoApplication.widthAnchor.constraint(equalToConstant: measureFrameForText(labelNoInfoApplication.text!).width + padding).isActive = true
    labelNoInfoApplication.heightAnchor.constraint(equalToConstant: ProfileScreenLoad.height(text: labelNoInfoApplication.text, font: labelNoInfoApplication.font, width:  labelNoInfoApplication.frame.width).height).isActive = true
    labelNoInfoApplication.bottomAnchor.constraint(equalTo: containerViewAppl.bottomAnchor).isActive = true
  }
  
  private func setUpGitContainer() {
    stackView.addArrangedSubview(containerViewGit)
    containerViewGit.translatesAutoresizingMaskIntoConstraints = false
    containerViewGit.topAnchor.constraint(equalTo: containerViewAppl.bottomAnchor, constant: padding).isActive = true
    containerViewGit.leftAnchor.constraint(equalTo: stackView.leftAnchor).isActive = true
    containerViewGit.rightAnchor.constraint(equalTo: stackView.rightAnchor).isActive = true
  }
  
  private func setUpGitLabel() {
    containerViewGit.addSubview(labelGitStat)
    labelGitStat.topAnchor.constraint(equalTo: containerViewGit.topAnchor, constant: padding).isActive = true
    labelGitStat.leftAnchor.constraint(equalTo: containerViewGit.leftAnchor, constant: padding).isActive = true
    containerViewGit.heightAnchor.constraint(equalToConstant: 400).isActive = true
  }
  
  private func setUpCollectionGit() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    
    collectionViewGit = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionViewGit?.delegate = self
    collectionViewGit?.dataSource = self
    collectionViewGit?.register(GitCell.self, forCellWithReuseIdentifier: GitCell.reusedId)
    collectionViewGit?.translatesAutoresizingMaskIntoConstraints = false
    if #available(iOS 13.0, *) {
      collectionViewGit?.backgroundColor = Brandbook.Colors.dark_light
    } else {
      // Fallback on earlier versions
    }
    
    containerViewGit.addSubview(collectionViewGit!)
    collectionViewGit?.topAnchor.constraint(equalTo: labelGitStat.bottomAnchor).isActive = true
    collectionViewGit?.leftAnchor.constraint(equalTo: containerViewGit.leftAnchor, constant: padding).isActive = true
    collectionViewGit?.rightAnchor.constraint(equalTo: containerViewGit.rightAnchor, constant: small).isActive = true
    //    MARK: для динамической высоты scrollView
    collectionViewGit?.bottomAnchor.constraint(equalTo: containerViewGit.bottomAnchor).isActive = true
    
    collectionViewGit?.addSubview(activityViewGit)
    activityViewGit.hidesWhenStopped = true
    activityViewGit.color = .gray
    activityViewGit.translatesAutoresizingMaskIntoConstraints = false
    activityViewGit.centerXAnchor.constraint(equalTo: collectionViewGit!.centerXAnchor).isActive = true
    activityViewGit.centerYAnchor.constraint(equalTo: collectionViewGit!.centerYAnchor).isActive = true
    activityViewGit.startAnimating()
    
    //    !!!!!
    
    
  }
  
  func setupProfileComponents() {
    setUpScrollView()
    setUpStackView()
    setUpContainerView()
    setUpProfileImageView()
    setText()
    setImage()
    setUpInsideContainerView()
    
    setUpAwardsContainer()
    setUpAwardsLabel()
    checkAwardsModel()
    setUpCollectionAwards()
    
    setUpProjContainer()
    setUpProjLabel()
    checkProjModel()
    setUpProjects()
    
    setUpApplContainer()
    setUpApplLabel()
    checkProjAppl()
    setUpApplications()
    
    setUpGitContainer()
    setUpGitLabel()
    setUpCollectionGit()
    
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if collectionView == collectionViewGit {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GitCell.reusedId, for: indexPath) as! GitCell
      cell.nameLabel.text = modelGitStat?.projects[indexPath.row].name
      if let number = modelGitStat?.projects[indexPath.row].commitCount {
        cell.comitNumber.text = String(number)
      }
      return cell
    }
    if collectionView == collectionViewAwards {
      
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AwardCell.reusedId, for: indexPath) as! AwardCell
      cell.nameLabel.text = modelAwards?.data[indexPath.row].name
      if let pic_url_base64 = modelAwards?.data[indexPath.row].image {
        let image = UIImage(base64: pic_url_base64)
        cell.awardImageView.image = image
      }
      
      cell.descriptionLabel.text = modelAwards?.data[indexPath.row].award_condition_description
      
      if let data = modelAwards?.data[indexPath.row].progress {
        cell.progressBar.setProgress(Float(data/100), animated: false)
      }
      return cell
    }
    return UICollectionViewCell()
    
    
  }
  
  private func setText() {
    self.profileStatus.text = modelProfile?[0].status
    self.nameLabel.text = (modelProfile?[0].items.name)?.components(separatedBy: " ")[1]
    self.surnameLabel.text = (modelProfile?[0].items.name)?.components(separatedBy: " ")[0]
    self.emailLabel.text = modelProfile?[0].items.email
    self.departLabel.text = modelProfile?[0].items.group
    
  }
  
  private func setImage() {
    
    if let pic_url = modelProfile?[0].items.pic {
      let url_string = "https://devcabinet.miem.vmnet.top\(pic_url)"
      let url = URL(string: url_string)
      if let url_pic = url {
        getData(from: url_pic) { data, response, error in
          guard let data = data, error == nil else {
            DispatchQueue.main.async() { [weak self] in
              self!.profileImageView.image = Brandbook.Images.Icons.userProfileIcon
            }
            return
            
          }
          DispatchQueue.main.async() { [weak self] in
            self!.profileImageView.image = UIImage(data: data)
          }
        }
      }
    }
    
    else {
      self.profileImageView.image = Brandbook.Images.Icons.userProfileIcon
    }
  }
  
  @objc
  func chatHandled(){
    if let url = URL(string: modelProfile?[0].items.chatLink ?? "https://chat.miem.hse.ru/") {
      UIApplication.shared.open(url)
    }
  }
  
  @objc
  func refresh() {
    refreshAction()
    refreshInfo()
    
  }
  
  func refreshInfo() {
    setText()
    setImage()
    self.profileStatus.reloadInputViews()
    self.profileStatus.reloadInputViews()
    self.nameLabel.reloadInputViews()
    self.surnameLabel.reloadInputViews()
    self.emailLabel.reloadInputViews()
    self.departLabel.reloadInputViews()
    applView.reloadInputViews()
    projectView.reloadInputViews()
  }
  
  private func endRefresh() {
    self.scrollView.reloadInputViews()
    scrollView.refreshControl?.endRefreshing()
    collectionViewAwards?.refreshControl?.endRefreshing()
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    guard let isRefreshing = scrollView.refreshControl?.isRefreshing, isRefreshing else {
      return
    }
    endRefresh()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if modelProfile == nil {
      scrollView.refreshControl?.beginRefreshing()
    }
    controller.reloadInputViews()
  }
  
  override func viewWillLayoutSubviews() {
    refresh()
    refreshInfo()
    scrollView.reloadInputViews()
  }
  
  private func measureFrameForText(_ text: String) -> CGRect{
    let size = CGSize(width: 200, height: 1000)
    let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
    return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
  }
  
  private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    switch collectionView {
    case collectionViewGit:
      return modelGitStat?.projects.count ?? 0
    case collectionViewAwards:
      return modelAwards?.data.count ?? 0
    default:
      return 0
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    switch collectionView {
    case collectionViewAwards:
      return CGSize(width: Brandbook.Heights.awardCell, height: Brandbook.Heights.awardCell)
      
    case collectionViewGit:
      return CGSize(width: UIScreen.main.bounds.width - 2*padding, height: Brandbook.Heights.gitCell)
      
    default:
      return CGSize(width: UIScreen.main.bounds.width - 2*padding, height: Brandbook.Heights.defaultHeight)
    }
  }
  
  
  func open(project_name: String, name: String, email: [String], studentComment: String, leaderComment: String, group: String, role: String, leader: String) {
    
    let vc = ApplicationMoreInfo(project_name: project_name, name: name, email: email, studentComment: studentComment, leaderComment: leaderComment, group: group, role: role, leader: leader)
    vc.view.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
    let popupVC = PopupViewController(contentController: vc, popupWidth: self.view.bounds.width-2*padding, popupHeight: 300)
    popupVC.canTapOutsideToDismiss = true
    popupVC.cornerRadius = 9
    present(popupVC, animated: true)
    
  }
}
private let padding = Brandbook.Paddings.normal
private let small = Brandbook.Paddings.small

extension ProfileScreenLoad {
  static func height(text: String?, font: UIFont, width: CGFloat) -> CGRect {
    var currentHeight: CGRect!
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    label.text = text
    label.font = font
    label.numberOfLines = 0
    label.sizeToFit()
    label.lineBreakMode = .byWordWrapping
    currentHeight = label.frame
    label.removeFromSuperview()
    return currentHeight
  }
}
