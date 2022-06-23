//
//  AuthScreenLoad.swift
//  MIEMApp
//
//  Created by Тимофей Фёдоров on 06.03.2021.
//

import GoogleSignIn
import SafariServices
import UIKit
import AppAuth


final class AuthScreenLoad: UIViewController, ScreenPayload {
  private let authServices: AuthServices
  private let onSuccess: () -> Void
  var controller: UIViewController {
    self
  }
  
  init(
    authServices: AuthServices,
    onSuccess: @escaping () -> Void
  ) {
    self.authServices = authServices
    self.onSuccess = onSuccess
    super.init(nibName: nil, bundle: nil)
    setUpViews()
    setUpGIDSignIn()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
  private func setUpViews() {
    controller.view.backgroundColor = .white

    let imageView = UIImageView(frame: .zero)
    imageView.image = Brandbook.Images.appLogo
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    controller.view.addSubview(imageView)
    imageView.centerYAnchor.constraint(equalTo: controller.view.topAnchor, constant: 250).isActive = true
    imageView.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor).isActive = true
    imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    
    let signInButton = Button("Авторизоваться")
    signInButton.addTarget(self, action: #selector(onSignInClicked), for: .touchUpInside)
    signInButton.translatesAutoresizingMaskIntoConstraints = false
    controller.view.addSubview(signInButton)
    signInButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: padding).isActive = true
    signInButton.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor).isActive = true
    
//    let signInButtonCabinet = Button("Авторизоваться новый токен")
//    signInButtonCabinet.addTarget(self, action: #selector(onSignInCabClicked), for: .touchUpInside)
//    signInButtonCabinet.translatesAutoresizingMaskIntoConstraints = false
//    controller.view.addSubview(signInButtonCabinet)
//    signInButtonCabinet.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: padding).isActive = true
//    signInButtonCabinet.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor).isActive = true
    
    
    let userAgreementButton = UIButton(type: .system)
    userAgreementButton.addTarget(self, action: #selector(onUserAgreementButtonClick), for: .touchUpInside)
    userAgreementButton.setTitle("Пользовательское соглашение", for: .normal)
    userAgreementButton.translatesAutoresizingMaskIntoConstraints = false
    controller.view.addSubview(userAgreementButton)
    userAgreementButton.bottomAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    userAgreementButton.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor, constant: padding).isActive = true
    userAgreementButton.trailingAnchor.constraint(equalTo: controller.view.trailingAnchor, constant: -padding).isActive = true
    
    let lableBottom = UILabel()
    lableBottom.text = "Нажимая кнопку авторизации, вы принимаете Пользовательское соглашение"
    lableBottom.numberOfLines = 0
    lableBottom.textAlignment = .center
    lableBottom.font = lableBottom.font.withSize(Brandbook.TextSize.normal)
    lableBottom.translatesAutoresizingMaskIntoConstraints = false
    controller.view.addSubview(lableBottom)
    lableBottom.bottomAnchor.constraint(equalTo: userAgreementButton.topAnchor, constant: -padding).isActive = true
    lableBottom.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor, constant: padding).isActive = true
    lableBottom.trailingAnchor.constraint(equalTo: controller.view.trailingAnchor, constant: -padding).isActive = true
  }
  
  @objc private func onSignInClicked() {
    GIDSignIn.sharedInstance().signIn()
  }
  
  @objc private func onSignInCabClicked() {
    self.signInCab()
  }
  
 
  
  
  @objc private func onUserAgreementButtonClick() {
    let safariVC = SFSafariViewController(url: URL(string: "http://19111.miem.vmnet.top/user_agreement")!)
    safariVC.modalPresentationStyle = .formSheet
    safariVC.dismissButtonStyle = .close
    present(safariVC, animated: true, completion: {})
  }
  
  private func setUpGIDSignIn() {
    GIDSignIn.sharedInstance().presentingViewController = self
    GIDSignIn.sharedInstance().delegate = self
  }
}

extension AuthScreenLoad: GIDSignInDelegate {
  func sign(
    _ signIn: GIDSignIn?,
    didSignInFor user: GIDGoogleUser?,
    withError error: Error?
  ) {
    if let error = error {
      if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
        print("The user has not signed in before or they have since signed out.")
      } else {
        print("\(error.localizedDescription)")
      }
      return
    }
    guard let authCode = user?.serverAuthCode else {
      return
    }
    authServices.logIn(authCode: authCode, completion: { [weak self] in
      if $0 {
        self?.onSuccess()
        
      }
    })
  }
  
  func signInCab() {
    authServices.logInCabinet(self, completion: { [weak self] in
      if $0 {
        self?.onSuccess()
      }
    })
  }
}

private let padding = Brandbook.Paddings.normal
