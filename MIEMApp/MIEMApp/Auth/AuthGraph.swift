//
//  AuthGraph.swift
//  MIEMApp
//
//  Created by Тимофей Фёдоров on 06.03.2021.
//

import UIKit
import GoogleSignIn

final class AuthGraph {
  let screen: Screen
  private let wireframe: Wireframe
  private let token: Property<String>
  private let onLogIn: () -> Void
  private let authScreenLoad: AuthScreenLoad
  private let authServices: AuthServices
  
  init(
    wireframe: Wireframe,
    token: Property<String>,
    user: Property<User>,
    onLogIn: @escaping () -> Void
  ) {
    self.wireframe = wireframe
    self.token = token
    self.onLogIn = onLogIn
    authServices = AuthServices(token: token, user: user)
    authScreenLoad = AuthScreenLoad(authServices: authServices, onSuccess: {
      onLogIn()
      wireframe.popAuthScreen()
    })
    screen = Screen(id: .authScreen, payload: authScreenLoad)
    setUpGIDSignIn()
  }
  
  func logIn() {
    guard token.value.isEmpty else {
      onLogIn()
      return
    }
    wireframe.pushAuthScreen()
  }
  
  func logOut() {
    authServices.logOut()
    wireframe.closeAll()
    wireframe.closeProfile()
    wireframe.pushAuthScreen()
  }
  
  private func setUpGIDSignIn() {
    GIDSignIn.sharedInstance().clientID = "861005331877-m5tbfn37csf6dufsbepqng40lmvbuhoh.apps.googleusercontent.com"
    GIDSignIn.sharedInstance().serverClientID = "861005331877-0r79ua1cm5osvqpvt07i831eapgl2b9a.apps.googleusercontent.com"
    GIDSignIn.sharedInstance().hostedDomain = "miem.hse.ru"
    GIDSignIn.sharedInstance().restorePreviousSignIn()
  }
}
