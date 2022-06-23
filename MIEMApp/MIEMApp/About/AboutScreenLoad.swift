//
//  AboutScreenLoad.swift
//  MIEMApp
//
//  Created by Melanie Kofman on 29.11.2020.
//

import UIKit

final class AboutScreenLoad: UIViewController, ScreenPayload {
  private let onExitClicked: () -> Void
  
  var controller: UIViewController {
    self
  }
  
  init(onExitClicked: @escaping () -> Void) {
    self.onExitClicked = onExitClicked
    super.init(nibName: nil, bundle: nil)
    setupAboutComponents()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    navigationController?.setNavigationBarHidden(false, animated: animated)
    if #available(iOS 13.0, *) {
      navigationController?.navigationBar.backgroundColor = Brandbook.Colors.dark_light
    } else {
      // Fallback on earlier versions
    }
  }
  
  
  func setupAboutComponents() {
    if #available(iOS 13.0, *) {
      controller.view.backgroundColor = Brandbook.Colors.dark_light
    } else {
      // Fallback on earlier versions
    }
    controller.edgesForExtendedLayout = []
    controller.title = "О приложении"
    
    let imageView = UIImageView(frame: .zero)
    imageView.image = Brandbook.Images.appLogo
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    controller.view.addSubview(imageView)
    imageView.topAnchor.constraint(equalTo: controller.view.topAnchor).isActive = true
    imageView.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor).isActive = true
    imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    
    let mainText: String = "Мобильное приложение для Кабинета проектной работы МИЭМ."
    let mainLabel = UILabel()
    mainLabel.text = mainText
    mainLabel.font = UIFont.systemFont(ofSize: 20)
    mainLabel.textAlignment = .left
    mainLabel.numberOfLines = 0
    mainLabel.translatesAutoresizingMaskIntoConstraints = false
    controller.view.addSubview(mainLabel)
    mainLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: padding).isActive = true
    mainLabel.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor, constant: padding).isActive = true
    mainLabel.trailingAnchor.constraint(equalTo: controller.view.trailingAnchor, constant: -padding).isActive = true
    
    
    
    if #available(iOS 13, *) {
      let switchTheme = UISwitch(frame:CGRect(x: 0, y: 0, width: 10, height: 10))
      switchTheme.translatesAutoresizingMaskIntoConstraints = false
      controller.view.addSubview(switchTheme)
      switchTheme.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: Brandbook.Paddings.normal).isActive = true
      switchTheme.rightAnchor.constraint(equalTo: controller.view.rightAnchor, constant: -Brandbook.Paddings.normal*2).isActive = true
      switchTheme.addTarget(self, action: #selector(self.switchStateDidChange(_:)), for: .valueChanged)
      switchTheme.setOn(false, animated: false)
      
      let labelSwitch = UILabel()
      labelSwitch.text = "Темная тема"
      labelSwitch.numberOfLines = 0
      labelSwitch.textAlignment = .justified
      labelSwitch.font = UIFont.systemFont(ofSize: 18)
      labelSwitch.translatesAutoresizingMaskIntoConstraints = false
      controller.view.addSubview(labelSwitch)
      labelSwitch.rightAnchor.constraint(equalTo: switchTheme.leftAnchor, constant: -Brandbook.Paddings.small).isActive = true
      labelSwitch.leftAnchor.constraint(equalTo: controller.view.leftAnchor, constant: 2*padding).isActive = true
      labelSwitch.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: Brandbook.Paddings.normal).isActive = true
      labelSwitch.centerYAnchor.constraint(equalTo: switchTheme.centerYAnchor).isActive = true
    }
    
    
    
    
    let lableBottom = UILabel()
    let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "🤡"
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "🤡"
    lableBottom.text = "Версия \(version) (\(build))"
    lableBottom.font = lableBottom.font.withSize(Brandbook.TextSize.normal)
    lableBottom.textColor = Brandbook.Colors.grey
    lableBottom.translatesAutoresizingMaskIntoConstraints = false
    controller.view.addSubview(lableBottom)
    lableBottom.bottomAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    lableBottom.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor).isActive = true
    let tap = UITapGestureRecognizer(target: self, action: #selector(getLogs))
    lableBottom.isUserInteractionEnabled = true
    lableBottom.addGestureRecognizer(tap)
    
    let exitButton = Button("Выйти из аккаунта")
    exitButton.backgroundColor = Brandbook.Colors.redColor
    exitButton.addTarget(self, action: #selector(onExitBtnClicked), for: .touchUpInside)
    exitButton.translatesAutoresizingMaskIntoConstraints = false
    controller.view.addSubview(exitButton)
    exitButton.bottomAnchor.constraint(equalTo: lableBottom.topAnchor, constant: -padding).isActive = true
    exitButton.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor).isActive = true
  }
  
  @objc private func onExitBtnClicked() {
    onExitClicked()
  }
  
  @objc private func switchStateDidChange(_ sender:UISwitch!) {
    if #available(iOS 13, *) {
      let appDelegate = UIApplication.shared.windows
      if (sender.isOn == true){
        appDelegate.forEach{$0.overrideUserInterfaceStyle = .dark}
        return
      }
      else{
        appDelegate.forEach{$0.overrideUserInterfaceStyle = .light}
        return
      }
    }
  }
  
  @objc private func getLogs() {
    UIPasteboard.general.string = Logger.shared.logString
    let message = "Логи скопированы"
    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    self.present(alert, animated: true)
    
    let duration: Double = 2
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
      alert.dismiss(animated: true)
    }
  }
}

private let padding = Brandbook.Paddings.normal
