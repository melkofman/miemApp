//
//  NavigationScreenLoad.swift
//  MIEMApp
//
//  Created by Melanie Kofman on 27.05.2022.
//

import UIKit
import Foundation
import NavigationModule
@available(iOS 13.0, *)
final class NavigationScreenLoad: UIViewController, ScreenPayload {
  var controller: UIViewController {
    self
  }
  var navController = UINavigationController()
  
  init (navController: NavigationController) {
  
    super.init(nibName: nil, bundle: nil)
    self.view.addSubview(self.navController.view)
    self.navController.addChild(navController)
    navController.didMove(toParent: self.navController)
    self.view.addSubview(navController.view)
   

  }
  
  override func viewWillAppear(_ animated: Bool) {
    navigationController?.setNavigationBarHidden(false, animated: animated)
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
