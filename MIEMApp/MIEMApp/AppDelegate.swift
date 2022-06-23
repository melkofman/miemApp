//
//  AppDelegate.swift
//  MIEMApp
//
//  Created by Тимофей Фёдоров on 15.11.2020.
//

import UIKit
import GoogleSignIn
import AppAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  let appGraph = AppGraph()
  var window: UIWindow?
  
  var currentAuthorizationFlow: OIDExternalUserAgentSession?
  var authState: OIDAuthState?
  
  func saveState() {
    var data: Data? = nil

    if let authState = self.authState {
    do {
    data = try NSKeyedArchiver.archivedData(withRootObject: authState, requiringSecureCoding: false)

    } catch { print("catch saveState: \(error)") }

    }
    UserDefaults.standard.set(data, forKey: "authState")
    UserDefaults.standard.synchronize()
  }
  
  func setAuthState(_ authState: OIDAuthState?) {
     if (self.authState == authState) {
     return;
     }
     self.authState = authState;
     self.saveState()
   }

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    setUpWindow()
    return true
  }
  
  func application(_ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any]
  ) -> Bool {
    GIDSignIn.sharedInstance().handle(url)
    
    
    if let authorizationFlow = self.currentAuthorizationFlow,
                               authorizationFlow.resumeExternalUserAgentFlow(with: url) {
      self.currentAuthorizationFlow = nil
      return true
    }

    // Your additional URL handling (if any)

    return false
  }
  
  private func setUpWindow() {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = appGraph.screenRouter.rootViewController
    window?.makeKeyAndVisible()
    window?.tintColor = Brandbook.Colors.tint
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    appGraph.applicationWillTerminate()
  }
}

